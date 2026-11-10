
module TopModule (
    input wire x3,
    input wire x2,
    input wire x1,
    output reg f
);

    
    always @(x3, x2, x1) begin
        if (x3 == 0 && x2 == 0 && x1 == 0) begin
            f = 0;
        end else if (x3 == 0 && x2 == 0 && x1 == 1) begin
            f = 0;
        end else if (x3 == 0 && x2 == 1 && x1 == 0) begin
            f = 1;
        end else if (x3 == 0 && x2 == 1 && x1 == 1) begin
            f = 1;
        end else if (x3 == 1 && x2 == 0 && x1 == 0) begin
            f = 0;
        end else if (x3 == 1 && x2 == 0 && x1 == 1) begin
            f = 1;
        end else if (x3 == 1 && x2 == 1 && x1 == 0) begin
            f = 0;
        end else if (x3 == 1 && x2 == 1 && x1 == 1) begin
            f = 1;
        end
    end

endmodule
