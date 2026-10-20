
module TopModule (
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

    
    localparam NUM_CELLS = 512;

    
    reg [NUM_CELLS-1:0] current_state;
    reg [NUM_CELLS-1:0] next_state;

    
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
        end
    end

    
    always @(posedge clk) begin
        
        next_state[0] = 0;
 
        next_state[NUM_CELLS-1] = 0;
 

        
        for (int i = 1;
 i < NUM_CELLS-1;
 i++) begin
            next_state[i] = current_state[i-1] ^ current_state[i+1];
        end
    end

    
    always @(posedge clk) begin
        current_state <= next_state;
    end

    
    assign q = current_state;

endmodule
