
module TopModule (
    input wire clk,
    input wire load,
    input wire [511:0] data,
    output reg [511:0] q
);

    
    reg [511:0] cells [0:511];

    
    always @(posedge clk) begin
        if (load) begin
            for (int i = 0;
 i <= 511;
 i = i + 1) begin
                cells[i] = data[i];
            end
        end
    end

    
    always @(posedge clk) begin
        for (int i = 0;
 i <= 511;
 i = i + 1) begin
            
            reg [1:0] left = cells[i - 1];
            reg [1:0] center = cells[i];
            reg [1:0] right = cells[i + 1];

            
            reg next_state = left ^ center ^ right;

            
            cells[i] = next_state;
        end
    end

    
    assign q = cells[511];

endmodule
