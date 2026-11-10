
module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    
    typedef enum {idle, sequence1, sequence2} state_t;

    
    state_t state = idle;

    
    reg [1:0] count = 0;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= idle;
            count <= 0;
        end else begin
            case (state)
                idle: begin
                    if (x == 1) begin
                        state <= sequence1;
                        count <= 0;
                    end
                end
                sequence1: begin
                    if (x == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 0;
                    end
                    if (count == 2) begin
                        state <= sequence2;
                    end
                end
                sequence2: begin
                    if (x == 1) begin
                        count <= count + 1;
                    end else begin
                        count <= 0;
                    end
                    if (count == 3) begin
                        state <= idle;
                        z <= 1;
                    end
                end
            endcase
        end
    end

endmodule
