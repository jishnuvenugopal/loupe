
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

        always @(posedge clk or negedge rst) begin
            if (rst) begin
                out <= 8'b00000000;
            end else begin
                if (sel == 2'b00) begin
                    out <= a;
                end else if (sel == 2'b01) begin
                    out <= b;
                end else if (sel == 2'b10) begin
                    out <= a;
                end else if (sel == 2'b11) begin
                    out <= b;
                end
            end
        end

    endmodule

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            out <= 8'b00000000;
        end else begin
            
            out[3:0] <= in[3:0];
            out[7:4] <= in[7:4];
            
            out[5:2] <= in[5:2];
            out[7:6] <= in[7:6];
            
            out[6:0] <= in[6:0];
        end
    end

endmodule
