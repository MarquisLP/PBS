module control(
    input clk,
    input reset_n,
    input go,
    input p_hp,
    input ai_hp,
	 output reg victory,
	 output reg loss,
    output reg active_trainer, apply_damage, target
    );

    reg [5:0] current_state, next_state; 
    
    localparam  S_LOAD_PM         = 5'd0,
                S_UPDATE_AI_HP    = 5'd1,
					 S_VIEW_UPDATED_AI_HP = 5'd2,
                S_UPDATE_P_HP     = 5'd3,
					 S_VIEW_UPDATED_P_HP = 5'd4,
                S_VICTORY         = 5'd5,
                S_LOSS            = 5'd6;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_PM: next_state = go ? S_UPDATE_AI_HP : S_LOAD_PM;
                S_UPDATE_AI_HP: next_state = S_VIEW_UPDATED_AI_HP;
					 S_VIEW_UPDATED_AI_HP:
					     begin
						      begin
						          if (go)
									    begin
									    if (ai_hp == 4'b0000)
											next_state = S_VICTORY;
										 else
											next_state = S_UPDATE_P_HP; 
										 end
								    else
									    next_state = S_VIEW_UPDATED_AI_HP;
								end
						  end
                S_UPDATE_P_HP: next_state = S_VIEW_UPDATED_AI_HP;
					 S_VIEW_UPDATED_P_HP:
					     begin
						      begin
						          if (go)
									    begin
									    if (p_hp == 4'b0000)
											next_state = S_LOSS;
										 else
											next_state = S_LOAD_PM; 
										 end
								    else
									    next_state = S_VIEW_UPDATED_P_HP;
								end
						  end
                S_VICTORY: next_state = S_VICTORY;
					 S_LOSS: next_state = S_LOSS;
                default:   next_state = S_LOAD_PM;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        active_trainer = 1'b0;
        target = 1'b0;
        apply_damage = 1'b0;
		  victory = 1'b0;
		  loss = 1'b0;

        case (current_state)
            S_UPDATE_AI_HP: begin
				    active_trainer = 1'b0; // 0 selects player as the active trainer
                target = 1'b1;
                apply_damage = 1'b1; // 1 selects the AI's Pokemon as target
                end
            S_UPDATE_P_HP: begin
				    active_trainer = 1'b1; // 1 selects AI as the active trainer
                target = 1'b0;  // 0 selects the player's Pokemon as target
                apply_damage = 1'b1;
                end
            S_VICTORY: begin
                victory = 1'b1;
                end
            S_LOSS: begin
                loss = 1'b1;
                end
            
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!reset_n)
            current_state <= S_LOAD_PM;
        else
            current_state <= next_state;
    end // state_FFS
endmodule
