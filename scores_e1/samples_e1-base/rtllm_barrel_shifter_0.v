
module barrel_shifter (
    input wire [7:0] in,
    input wire [2:0] ctrl,
    output reg [7:0] out
);

    
    module mux2X1 (
        input wire [1:0] sel,
        input wire [7:0] a,
        input wire [7:0] b,
        output reg [7:0] out
    );
        always @(posedge clk) begin
            if (sel == 2'b00) out <= a;
            else out <= b;
        end
    endmodule

    
    always @(posedge clk) begin
        
        if (ctrl[2] == 1'b1) begin
            out[3:0] <= in[3:0];
            out[7:4] <= in[7:4];
        end

        
        if (ctrl[1] == 1'b1) begin
            out[5:2] <= in[5:2];
            out[7:6] <= in[7:6];
        end

        
        if (ctrl[0] == 1'b1) begin
            out[6] <= in[6];
            out[7] <= in[7];
        end
    end

endmodule
