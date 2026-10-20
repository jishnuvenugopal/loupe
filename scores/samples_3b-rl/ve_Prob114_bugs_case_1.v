
module TopModule (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  code,
    output reg  [3:0]  out,
    output reg         valid
);

    
    wire [7:0] key0 = 8'h45;
 
    wire [7:0] key1 = 8'h16;
 
    wire [7:0] key2 = 8'h1e;
 
    wire [7:0] key3 = 8'h26;
 
    wire [7:0] key4 = 8'h25;
 
    wire [7:0] key5 = 8'h2e;
 
    wire [7:0] key6 = 8'h36;
 
    wire [7:0] key7 = 8'h3d;
 
    wire [7:0] key8 = 8'h3e;
 
    wire [7:0] key9 = 8'h46;
 

    
    reg [9:0] match;

    always @(posedge clk) begin
        if (rst) begin
            match  <= 10'b0;
            out    <= 4'b0;
            valid  <= 1'b0;
        end else begin
            
            if (code == key0) begin
                match <= 10'b1000000000;
            end else if (code == key1) begin
                match <= 10'b0100000000;
            end else if (code == key2) begin
                match <= 10'b0010000000;
            end else if (code == key3) begin
                match <= 10'b0001000000;
            end else if (code == key4) begin
                match <= 10'b0000100000;
            end else if (code == key5) begin
                match <= 10'b0000010000;
            end else if (code == key6) begin
                match <= 10'b0000001000;
            end else if (code == key7) begin
                match <= 10'b0000000100;
            end else if (code == key8) begin
                match <= 10'b0000000010;
            end else if (code == key9) begin
                match <= 10'b0000000001;
            end else begin
                match <= 10'b0;
            end

            
            if (match[9]) begin
                out    <= 4'b0000;
                valid  <= 1'b1;
            end else if (match[8]) begin
                out    <= 4'b0001;
                valid  <= 1'b1;
            end else if (match[7]) begin
                out    <= 4'b0010;
                valid  <= 1'b1;
            end else if (match[6]) begin
                out    <= 4'b0011;
                valid  <= 1'b1;
            end else if (match[5]) begin
                out    <= 4'b0100;
                valid  <= 1'b1;
            end else if (match[4]) begin
                out    <= 4'b0101;
                valid  <= 1'b1;
            end else if (match[3]) begin
                out    <= 4'b0110;
                valid  <= 1'b1;
            end else if (match[2]) begin
                out    <= 4'b0111;
                valid  <= 1'b1;
            end else if (match[1]) begin
                out    <= 4'b1000;
                valid  <= 1'b1;
            end else if (match[0]) begin
                out    <= 4'b1001;
                valid  <= 1'b1;
            end else begin
                out    <= 4'b0;
                valid  <= 1'b0;
            end
        end
    end

endmodule
