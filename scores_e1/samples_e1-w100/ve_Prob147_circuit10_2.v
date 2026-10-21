
module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

    
    reg [1:0] flip_flop;

    
    always @(posedge clk) begin
        if (flip_flop == 2'b00) begin
            if (a == 1'b1 && b == 1'b1) begin
                flip_flop <= 2'b01;
            end else if (a == 1'b0 && b == 1'b0) begin
                flip_flop <= 2'b00;
            end else if (a == 1'b1 && b == 1'b0) begin
                flip_flop <= 2'b01;
            end else if (a == 1'b0 && b == 1'b1) begin
                flip_flop <= 2'b01;
            end
        end else if (flip_flop == 2'b01) begin
            if (a == 1'b1 && b == 1'b1) begin
                flip_flop <= 2'b10;
            end else if (a == 1'b0 && b == 1'b0) begin
                flip_flop <= 2'b00;
            end else if (a == 1'b1 && b == 1'b0) begin
                flip_flop <= 2'b10;
            end else if (a == 1'b0 && b == 1'b1) begin
                flip_flop <= 2'b10;
            end
        end
    end

    
    always @(*) begin
        if (flip_flop == 2'b00) begin
            q <= 1'b0;
        end else if (flip_flop == 2'b01) begin
            q <= 1'b1;
        end else if (flip_flop == 2'b10) begin
            q <= 1'b0;
        end else if (flip_flop == 2'b11) begin
            q <= 1'b1;
        end
    end

    
    assign state = flip_flop;

endmodule
