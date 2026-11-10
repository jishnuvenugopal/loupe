
module TopModule (
    input wire clk,
    input wire a,
    input wire b,
    output reg state,
    output reg q
);

    
    reg [1:0] flip_flop;

    
    always @(posedge clk) begin
        if (flip_flop == 2'b00) begin
            if (a == 1'b1) begin
                flip_flop <= 2'b01;
            end else if (b == 1'b1) begin
                flip_flop <= 2'b10;
            end
        end else if (flip_flop == 2'b01) begin
            if (a == 1'b1) begin
                flip_flop <= 2'b10;
            end else if (b == 1'b1) begin
                flip_flop <= 2'b00;
            end
        end else if (flip_flop == 2'b10) begin
            if (a == 1'b1) begin
                flip_flop <= 2'b00;
            end else if (b == 1'b1) begin
                flip_flop <= 2'b11;
            end
        end
    end

    
    assign q = flip_flop;

endmodule
