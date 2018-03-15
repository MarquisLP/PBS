module control(
    input clk,
    input resetn,
    input go,
    input hp_is_zero,

    output reg  ld_pm, calc_ph, apply_ad, ld_am, calc_ah, apply_pd, victory, loss,
    output reg  ld_alu_out,
    output reg [1:0]  alu_select_a, alu_select_b,
    output reg alu_op
    );

    reg [5:0] current_state, next_state; 
    
    localparam  S_LOAD_PM         = 5'd0,
                S_CALC_PH         = 5'd1,
                S_APPLY_AD        = 5'd2,
                S_LOAD_AM         = 5'd3,
                S_CALC_AH         = 5'd4,
                S_APPLY_PD        = 5'd5,
                S_VICTORY         = 5'd6,
                S_LOSS            = 5'd7;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_PM: next_state = go ? S_CALC_PH : S_LOAD_PM;
                S_S_CALC_PH: next_state = go ? S_APPLY_AD : S_CALC_PH;
                S_APPLY_AD:
                    begin
                        if (hp_is_zero)
                            next_state = S_VICTORY;
                        else if (go)
                            next_state = S_LOAD_AM;
                        else:
                            next_state = S_APPLY_AD;
                    end
                S_LOAD_AM: next_state = go ? S_CALC_AH : S_LOAD_AM;
                S_CALC_AH: next_state = go ? S_APPLY_PD : S_CALC_AH;
                S_APPLY_PD:
                    begin
                        if (hp_is_zero)
                            next_state = S_LOSS;
                        else if (go)
                            next_state = S_LOAD_PM;
                        else:
                            next_state = S_APPLY_PD;
                    end
                S_VICTORY: next_state = reset_n ? S_LOAD_PM : S_VICTORY;
                S_LOSS: next_state = reset_n ? S_LOAD_PM : S_LOSS;
                default:   next_state = S_LOAD_PM;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_pm = 1'b0;
        calc_ph = 1'b0;
        apply_ad = 1'b0;
        ld_am = 1'b0;
        calc_ah = 1'b0;
        apply_ph = 1'b0;
        victory = 1'b0;
        loss = 1'b0;

        case (current_state)
            S_LOAD_PM: begin
                ld_pm = 1'b1;
                end
            S_CALC_PH: begin
                calc_ph = 1'b1;
                end
            S_APPLY_AH: begin
                apply_ah = 1'b1;
                end
            S_LOAD_AM: begin
                load_am = 1'b1;
                end
            S_CALC_AH: begin
                calc_ah = 1'b1;
                end
            S_APPLY_PD: begin
                apply_pd = 1'b1;
                end
            S_VICTORY: begin
                loss = 1'b1;
                end
            S_LOSS: begin
                loss = 1'b1;
                end
            end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_PM;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
    input clk,
    input resetn,
    input [7:0] data_in,
    input ld_alu_out, 
    input ld_x, ld_a, ld_b, ld_c,
    input ld_r,
    input alu_op, 
    input [1:0] alu_select_a, alu_select_b,
    output reg [7:0] data_result
    );
    
    // input registers
    reg [7:0] a, b, c, x;

    // output of the alu
    reg [7:0] alu_out;
    // alu input muxes
    reg [7:0] alu_a, alu_b;
    
    // Registers a, b, c, x with respective input logic
    always@(posedge clk) begin
        if(!resetn) begin
            a <= 8'b0; 
            b <= 8'b0; 
            c <= 8'b0; 
            x <= 8'b0; 
        end
        else begin
            if(ld_a)
                a <= ld_alu_out ? alu_out : data_in; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if(ld_b)
                b <= ld_alu_out ? alu_out : data_in; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if(ld_x)
                x <= data_in;

            if(ld_c)
                c <= data_in;
        end
    end
 
    // Output result register
    always@(posedge clk) begin
        if(!resetn) begin
            data_result <= 8'b0; 
        end
        else 
            if(ld_r)
                data_result <= alu_out;
    end

    // The ALU input multiplexers
    always @(*)
    begin
        case (alu_select_a)
            2'd0:
                alu_a = a;
            2'd1:
                alu_a = b;
            2'd2:
                alu_a = c;
            2'd3:
                alu_a = x;
            default: alu_a = 8'b0;
        endcase

        case (alu_select_b)
            2'd0:
                alu_b = a;
            2'd1:
                alu_b = b;
            2'd2:
                alu_b = c;
            2'd3:
                alu_b = x;
            default: alu_b = 8'b0;
        endcase
    end

    // The ALU 
    always @(*)
    begin : ALU
        // alu
        case (alu_op)
            0: begin
                   alu_out = alu_a + alu_b; //performs addition
               end
            1: begin
                   alu_out = alu_a * alu_b; //performs multiplication
               end
            default: alu_out = 8'b0;
        endcase
    end
    
endmodule
