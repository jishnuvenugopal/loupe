
module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    
    reg [2:0] count;
    reg [1:0] state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (slowena) begin
                        count <= count + 1;
                        if (count == 9) begin
                            count <= 0;
                        end
                    end
                end
                1: begin
                    count <= count + 1;
                    if (count == 9) begin
                        count <= 0;
                    end
                end
                2: begin
                    count <= count + 1;
                    if (count == 9) begin
                        count <= 0;
                    end
                end
                3: begin
                    count <= count + 1;
                    if (count == 9) begin
                        count <= 0;
                    end
                end
                4: begin
                    count <= count + 1;
                    if (count == 9) begin
                        count <= 0;
                    end
                end
                5: begin
                    count <= count + 1;
                    if (count == 9) begin
                        count <= 0;
                    end
                end
                6: begin
                    count <= count + 1;
                    if (count == 9) begin
                        count <= 0;
                    end
                end
                7: begin
                    count <= count + 1;
                    if (count == 9) begin
                        count <= 0;
                    end
                end
                8: begin
                    count <= count + 1;
                    if (count == 9) begin
                        count <= 0;
                    end
                end
                9: begin
                    count <= 0;
                    state <= 0;
                end
            endcase
        end
    end

    
    always @(*) begin
        q = count;
    end

endmodule
