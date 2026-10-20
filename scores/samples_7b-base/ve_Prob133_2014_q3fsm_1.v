
module TopModule(input clk, input reset, input s, input w, output reg z);
    reg [1:0] state;
    reg [2:0] w_count;
 
    reg w_flag;
         

    parameter A = 2'b00, B = 2'b01, D = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            w_count <= 0;
            w_flag <= 0;
            z <= 0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        w_count <= 0;
                        w_flag <= 0;
                    end
                end
                B: begin
                    w_count <= w_count + w;
                    if (w_count == 2) w_flag <= 1;
                    if (w_count > 2) w_flag <= 0;
                    if (w_count == 3) begin
                        state <= B;
                        w_count <= 0;
                        w_flag <= 0;
                    end
                end
                D: begin
                    if (w) z <= 1;
                    if (!w) z <= 0;
                    state <= A;
                end
            endcase
        end
    end
endmodule
