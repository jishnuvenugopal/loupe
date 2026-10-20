
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    
    typedef enum {
        S0,       
        S1_0,     
        S2_0,     
        S3_0,     
        S4_0,     
        S5_0,     
        S6_0,     
        S1_1,     
        S2_1,     
        S3_1,     
        S4_1,     
        S5_1,     
        S6_1,     
        S7        
    } state_t;

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
            
            case (next_state)
                S6_0: flag <= 1;
                S0: begin
                    if (current_state == S6_0 && in == 0)
                        disc <= 1;
                    else if (current_state == S6_1 && in == 1)
                        flag <= 1;
                end
                S7: err <= 1;
                default: ;
            endcase
        end
    end

    
    always @(*) begin
        case (current_state)
            S0: begin
                if (in) next_state = S1_1;
                else next_state = S0;
            end
            S1_0: begin
                if (in) next_state = S2_0;
                else next_state = S0;
            end
            S2_0: begin
                if (in) next_state = S3_0;
                else next_state = S0;
            end
            S3_0: begin
                if (in) next_state = S4_0;
                else next_state = S0;
            end
            S4_0: begin
                if (in) next_state = S5_0;
                else next_state = S0;
            end
            S5_0: begin
                if (in) next_state = S6_0;
                else next_state = S0;
            end
            S6_0: begin
                if (in) next_state = S7;
                else next_state = S0;
            end
            S1_1: begin
                if (in) next_state = S2_1;
                else next_state = S0;
            end
            S2_1: begin
                if (in) next_state = S3_1;
                else next_state = S0;
            end
            S3_1: begin
                if (in) next_state = S4_1;
                else next_state = S0;
            end
            S4_1: begin
                if (in) next_state = S5_1;
                else next_state = S0;
            end
            S5_1: begin
                if (in) next_state = S6_1;
                else next_state = S0;
            end
            S6_1: begin
                if (in) next_state = S7;
                else next_state = S0;
            end
            S7: begin
                if (in) next_state = S7;
                else next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

endmodule
