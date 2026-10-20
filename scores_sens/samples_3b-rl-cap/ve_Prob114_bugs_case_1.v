
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

    
    reg [9:0] match;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out  <= 4'b0;
            valid <= 1'b0;
        end else begin
            
            match = 10'b0;
            match[0] = (code == key0);
            match[1] = (code == key1);
            match[2] = (code == key2);
            match[3] = (code == key3);
            match[4] = (code == key4);
            match[5] = (code == key5);
            match[6] = (code == key6);
            match[7] = (code == key7);
            match[8] = (code == key8);
            match[9] = (code == key9);

            if (match[9]) begin
                
                out  <= 4'b0;
                valid <= 1'b1;
            end else if (match[8]) begin
                
                out  <= 4'b1;
                valid <= 1'b1;
            end else if (match[7]) begin
                
                out  <= 4'b2;
                valid <= 1'b1;
            end else if (match[6]) begin
                
                out  <= 4'b3;
                valid <= 1'b1;
            end else if (match[5]) begin
                
                out  <= 4'b4;
                valid <= 1'b1;
            end else if (match[4]) begin
                
                out  <= 4'b5;
                valid <= 1'b1;
            end else if (match[3]) begin
                
                out  <= 4'b6;
                valid <= 1'b1;
            end else if (match[2]) begin
                
                out  <= 4'b7;
                valid <= 1'b1;
            end else if (match[1]) begin
                
                out  <= 4'b8;
                valid <= 1'b1;
            end else if (match[0]) begin
                
                out  <= 4'b9;
                valid <= 1'b1;
            end else begin
                
                out  <= 4'b0;
                valid <= 1'b0;
            end
        end
    end

endmodule
