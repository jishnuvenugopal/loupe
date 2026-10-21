
module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    
    reg [1:0] flip_flop = 2'b00;

    
    always @(posedge clk) begin
        if (flip_flop == 2'b00) begin
            if (a == 1 && b == 1) begin
                flip_flop <= 2'b01;
            end else if (a == 0 && b == 0) begin
                flip_flop <= 2'b00;
            end
        end else if (flip_flop == 2'b01) begin
            if (a == 1 && b == 1) begin
                flip_flop <= 2'b11;
            end else if (a == 0 && b == 0) begin
                flip_flop <= 2'b00;
            end
        end
    end

    
    assign q = flip_flop[0];

    
    assign state = flip_flop[1];

endmodule
