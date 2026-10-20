
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    
    parameter S0 = 4'd0;
  
    parameter S1 = 4'd1;
  
    parameter S2 = 4'd2;
  
    parameter S3 = 4'd3;
  
    parameter S4 = 4'd4;
  
    parameter S5 = 4'd5;
  
    parameter S6 = 4'd6;
  
    parameter S7 = 4'd7;
  

    reg [3:0] current_state, next_state;

    
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;
            
            disc <= 0;
            flag <= 0;
            err <= 0;

            case (current_state)
                S0: begin
                    if (in) begin
                        next_state = S1;
                    end else begin
                        next_state = S0;
                    end
                end
                S1: begin
                    if (in) begin
                        next_state = S2;
                    end else begin
                        next_state = S0;
                    end
                end
                S2: begin
                    if (in) begin
                        next_state = S3;
                    end else begin
                        next_state = S0;
                    end
                end
                S3: begin
                    if (in) begin
                        next_state = S4;
                    end else begin
                        next_state = S0;
                    end
                end
                S4: begin
                    if (in) begin
                        next_state = S5;
                    end else begin
                        next_state = S0;
                    end
                end
                S5: begin
                    if (in) begin
                        next_state = S6;
                    end else begin
                        next_state = S0;
                        disc <= 1;
 
                    end
                end
                S6: begin
                    if (in) begin
                        next_state = S7;
                        err <= 1;
 
                    end else begin
                        next_state = S0;
                        flag <= 1;
 
                    end
                end
                S7: begin
                    if (in) begin
                        next_state = S7;
                        err <= 1;
 
                    end else begin
                        next_state = S0;
                        flag <= 1;
 
                    end
                end
                default: next_state = S0;
            endcase
        end
    end

endmodule
