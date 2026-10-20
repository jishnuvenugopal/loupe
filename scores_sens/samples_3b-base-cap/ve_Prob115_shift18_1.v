
module TopModule (
    input  clk,
    input  load,
    input  ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);


reg [63:0] register_array [0:63];


always @(posedge clk or posedge load) begin
    if (load) begin
        register_array <= data;
    end
end


always @(posedge clk or posedge ena) begin
    if (ena) begin
        
        reg [1:0] shift_direction = amount[1:0];
        
        reg [3:0] shift_amount = amount[3:0];

        
        case (shift_direction)
            2'b00: begin 
                for (int i = 0;
 i < 63;
 i++) begin
                    register_array[i] <= register_array[i + 1];
                end
                register_array[63] <= 1'b0;
            end
            2'b01: begin 
                for (int i = 0;
 i < 63;
 i++) begin
                    register_array[i] <= register_array[i + 8];
                end
                register_array[55:0] <= 64'h0;
            end
            2'b10: begin 
                for (int i = 63;
 i > 0;
 i--) begin
                    register_array[i] <= register_array[i - 1];
                end
                register_array[0] <= 1'b0;
            end
            2'b11: begin 
                for (int i = 63;
 i > 7;
 i--) begin
                    register_array[i] <= register_array[i - 8];
                end
                register_array[7:0] <= 64'h0;
            end
        endcase
    end
end


assign q = register_array;

endmodule
