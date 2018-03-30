module control(
    input clk,
    input reset_n,
    input go,
    input p_hp,
	 input ai_dead,
	 input p_dead,
	 output reg victory,
	 output reg loss,
    output reg active_trainer, load_ai_hp, apply_p_damage, apply_ai_damage, target,
	 output reg state1, state2, state3
    );

    reg [5:0] current_state, next_state; 
    
    localparam  S_LOAD_PM         = 4'd0,
                S_UPDATE_AI_HP    = 4'd1,
                S_UPDATE_P_HP     = 4'd2,
                S_VICTORY         = 4'd3,
                S_LOSS            = 4'd4;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
	         if (ai_dead)
			       next_state = S_VICTORY;
			   else if (p_dead)
				    next_state = S_LOSS;
			   else begin
					case (current_state)
						 S_LOAD_PM: next_state = S_UPDATE_AI_HP;
						 S_UPDATE_AI_HP: next_state = S_UPDATE_P_HP; 
					    S_UPDATE_P_HP: next_state = S_LOAD_PM; 
	//                S_UPDATE_P_HP: next_state = S_VIEW_UPDATED_P_HP;
	//					 S_VIEW_UPDATED_P_HP:
	//					     //begin
	//						      begin
	//						          if (go)
	//									    begin
	//									    if (p_hp == 4'd0)
	//											next_state = S_LOSS;
	//										 else
	//											next_state = S_VPHP_TO_LPM;
	//										 end
	//								    else
	//									    next_state = S_VIEW_UPDATED_P_HP;
	//								end
	//						  //end
	//				    S_VPHP_TO_LPM: next_state = S_LOAD_PM;
						 S_VICTORY: next_state = S_VICTORY;
						 S_LOSS: next_state = S_LOSS;
						 default:   next_state = S_LOAD_PM;
				  endcase
		      end
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        active_trainer = 1'b0;
        target = 1'b0;
		  load_ai_hp = 1'b0;
		  apply_p_damage = 1'b0;
        apply_ai_damage = 1'b0;
		  victory = 1'b0;
		  loss = 1'b0;
		  state1 = 1'b0;
		  state2 = 1'b0;
		  state3 = 1'b0;

        case (current_state)
		      S_LOAD_PM: begin
				    state1 = 1'b1;
					 end
            S_UPDATE_AI_HP: begin
				    active_trainer = 1'b0; // 0 selects player as the active trainer
                target = 1'b1;  // 1 selects the AI's Pokemon as target
                apply_ai_damage = 1'b1;
					 state2 = 1'b1;
                end
            S_UPDATE_P_HP: begin
				    active_trainer = 1'b1; // 1 selects AI as the active trainer
                target = 1'b0;  // 0 selects the player's Pokemon as target
                apply_p_damage = 1'b1;
					 state3 = 1'b1;
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
