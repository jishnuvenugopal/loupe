
module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    reg a_prev;

    always @(posedge clk) begin
        if (!rst_n) begin
            rise <= 0;
            down <= 0;
            a_prev <= 0;
        end else begin
            if (a_prev == 0 && a == 1) begin
                
                rise <= 1;
                down <= 0;
                a_prev <= 1;
            end else if (a_prev == 1 && a == 0) begin
                
                rise <= 0;
                down <= 1;
                a_prev <= 0;
            end else begin
                rise <= 0;
                down <= 0;
            end
        end
    end

endmodule
