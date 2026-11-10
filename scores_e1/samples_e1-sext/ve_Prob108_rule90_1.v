
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    
    localparam WIDTH = 512;

    
    reg [WIDTH-1:0] state;

    
    reg [WIDTH-1:0] cells[WIDTH-1:0];

    
    initial begin
        state = 0;
        for (int i = 0;
 i < WIDTH;
 i++) begin
            cells[i] = 0;
        end
    end

    
    always @(posedge clk) begin
        if (load) begin
            state = data;
            for (int i = 0;
 i < WIDTH;
 i++) begin
                cells[i] = state[i];
            end
        end else begin
            for (int i = 0;
 i < WIDTH;
 i++) begin
                
                int left = (i == 0) ? WIDTH - 1 : i - 1;
                int right = (i == WIDTH - 1) ? 0 : i + 1;
                int center = i;

                
                if (cells[left] == 1 && cells[center] == 1 && cells[right] == 1) begin
                    state[center] = 0;
                end else if (cells[left] == 1 && cells[center] == 1 && cells[right] == 0) begin
                    state[center] = 1;
                end else if (cells[left] == 1 && cells[center] == 0 && cells[right] == 1) begin
                    state[center] = 0;
                end else if (cells[left] == 1 && cells[center] == 0 && cells[right] == 0) begin
                    state[center] = 1;
                end else if (cells[left] == 0 && cells[center] == 1 && cells[right] == 1) begin
                    state[center] = 1;
                end else if (cells[left] == 0 && cells[center] == 1 && cells[right] == 0) begin
                    state[center] = 0;
                end else if (cells[left] == 0 && cells[center] == 0 && cells[right] == 1) begin
                    state[center] = 0;
                end else if (cells[left] == 0 && cells[center] == 0 && cells[right] == 0) begin
                    state[center] = 0;
                end
            end
        end
    end

    
    assign q = state;

endmodule
