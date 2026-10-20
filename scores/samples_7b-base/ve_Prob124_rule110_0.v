
module TopModule(
    input wire clk,
    input wire load,
    input wire [511:0] data,
    output reg [511:0] q
);

reg [515:0] cell_state;
reg [515:0] next_state;


initial begin
    cell_state = {1'b0, data, 1'b0};
end

always @(posedge clk) begin
    if (load) begin
        cell_state <= {1'b0, data, 1'b0};
    end else begin
        
        for (integer i = 1;
 i < 512;
 i = i + 1) begin
            case ({cell_state[i-1], cell_state[i], cell_state[i+1]})
                3'b111: next_state[i] = 0;
                3'b110: next_state[i] = 1;
                3'b101: next_state[i] = 1;
                3'b100: next_state[i] = 0;
                3'b011: next_state[i] = 1;
                3'b010: next_state[i] = 1;
                3'b001: next_state[i] = 1;
                default: next_state[i] = 0;
            endcase
        end

        
        next_state[0] = 0;
        next_state[512] = 0;

        cell_state <= {next_state[1], next_state[1:512], next_state[511]};
    end
end


assign q = cell_state[1:512];

endmodule
