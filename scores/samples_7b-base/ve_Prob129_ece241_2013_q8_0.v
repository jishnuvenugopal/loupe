
module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    
    reg [1:0] state, next_state;

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
 
        end else begin
            state <= next_state;
 
        end
    end

    
    always @(*) begin
        case (state)
            S0: begin
                if (x == 1'b1) begin
                    next_state = S1;
                end else begin
                    next_state = S0;
                end
            end
            S1: begin
                if (x == 1'b0) begin
                    next_state = S2;
                end else begin
                    next_state = S0;
                end
            end
            S2: begin
                if (x == 1'b1) begin
                    next_state = S3;
                end else begin
                    next_state = S0;
                end
            end
            S3: begin
                next_state = S3;
 
            end
            default: begin
                next_state = S0;
 
            end
        endcase
    end

    
    always @(*) begin
        case (state)
            S0: z = 1'b0;
            S1: z = 1'b0;
            S2: z = 1'b0;
            S3: z = 1'b1;
 
            default: z = 1'b0;
 
        endcase
    end

endmodule
