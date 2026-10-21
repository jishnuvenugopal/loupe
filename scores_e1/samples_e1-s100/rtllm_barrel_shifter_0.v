
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
            
            reg [7:0] shifted_in = in;
            if (ctrl[2] == 1'b1) begin
                shifted_in = shifted_in >> 4;
            end
            
            if (ctrl[1] == 1'b1) begin
                shifted_in = shifted_in >> 2;
            end
            
            if (ctrl[0] == 1'b1) begin
                shifted_in = shifted_in >> 1;
            end
            
            out <= mux2X1_inst.out;
        end
    end

endmodule
