
module TopModule (
    input        clk,
    input        rst,
    input  [7:0] code,
    output reg [3:0] out,
    output reg       valid
);

    
    localparam [7:0] key0 = 8'h45;
 
    localparam [7:0] key1 = 8'h16;
 
    localparam [7:0] key2 = 8'h1e;
 
    localparam [7:0] key3 = 8'h26;
 
    localparam [7:0] key4 = 8'h25;
 
    localparam [7:0] key5 = 8'h2e;
 
    localparam [7:0] key6 = 8'h36;
 
    localparam [7:0] key7 = 8'h3d;
 
    localparam [7:0] key8 = 8'h3e;
 
    localparam [7:0] key9 = 8'h46;
 

    
    reg [9:0] key_code;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            key_code <= 10'd0;
            out      <= 4'd0;
            valid    <= 1'b0;
        end else begin
            if (code == key0) begin
                key_code <= 10'd0;
                out      <= 4'd0;
                valid    <= 1'b1;
            end else if (code == key1) begin
                key_code <= 10'd1;
                out      <= 4'd1;
                valid    <= 1'b1;
            end else if (code == key2) begin
                key_code <= 10'd2;
                out      <= 4'd2;
                valid    <= 1'b1;
            end else if (code == key3) begin
                key_code <= 10'd3;
                out      <= 4'd3;
                valid    <= 1'b1;
            end else if (code == key4) begin
                key_code <= 10'd4;
                out      <= 4'd4;
                valid    <= 1'b1;
            end else if (code == key5) begin
                key_code <= 10'd5;
                out      <= 4'd5;
                valid    <= 1'b1;
            end else if (code == key6) begin
                key_code <= 10'd6;
                out      <= 4'd6;
                valid    <= 1'b1;
            end else if (code == key7) begin
                key_code <= 10'd7;
                out      <= 4'd7;
                valid    <= 1'b1;
            end else if (code == key8) begin
                key_code <= 10'd8;
                out      <= 4'd8;
                valid    <= 1'b1;
            end else if (code == key9) begin
                key_code <= 10'd9;
                out      <= 4'd9;
                valid    <= 1'b1;
            end else begin
                out      <= 4'd0;
                valid    <= 1'b0;
            end
        end
    end

endmodule
