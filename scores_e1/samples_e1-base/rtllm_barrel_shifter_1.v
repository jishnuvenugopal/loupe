
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
                out <= sel == 2'b00 ? a : b;
            end
        end

    endmodule

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            out <= 8'b00000000;
        end else begin
            
            reg [7:0] shifted1 = in[3:0];
            
            reg [7:0] shifted2 = shifted1[3:0];
            
            reg [7:0] shifted3 = shifted2[3:0];

            
            reg [7:0] filled_out = {8'b00000000, shifted3};

            
            reg [1:0] sel = {ctrl[2], ctrl[1], ctrl[0]};
            out <= sel == 2'b00 ? filled_out : filled_out;
        end
    end

endmodule
