
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire [1:0] byteena,
    input  wire [15:0] d,
    output reg [15:0] q
);

    
    reg [15:0] dff [15:0];

    integer i;

    always @(posedge clk) begin
        if (resetn) begin
            
            for (i = 0;
 i < 16;
 i = i + 1) begin
                dff[i] <= 16'b0;
            end
        end else begin
            
            if (byteena[1]) begin
                
                for (i = 0;
 i < 8;
 i = i + 1) begin
                    dff[i] <= d[15:8];
                end
                
                for (i = 8;
 i < 16;
 i = i + 1) begin
                    dff[i] <= 8'b0;
                end
            end else if (byteena[0]) begin
                
                for (i = 0;
 i < 8;
 i = i + 1) begin
                    dff[i] <= d[7:0];
                end
                
                for (i = 8;
 i < 16;
 i = i + 1) begin
                    dff[i] <= 8'b0;
                end
            end
            
        end
    end

    
    assign q = dff;

endmodule
