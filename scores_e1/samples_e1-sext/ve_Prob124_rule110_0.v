
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    
    localparam WIDTH = 512;

    
    reg [WIDTH-1:0] cells[WIDTH-1:0];

    
    reg [WIDTH-1:0] current_state[WIDTH-1:0];

    
    initial begin
        q = 0;
    end

    
    always @(posedge clk) begin
        if (load) begin
            q = data;
        end
    end

    
    always @(posedge clk) begin
        
        for (int i = 0;
 i < WIDTH;
 i++) begin
            current_state[i] = q[i];
        end

        
        for (int i = 0;
 i < WIDTH;
 i++) begin
            
            reg [1:0] left = i == 0 ? 2'b00 : current_state[i-1];
            reg [1:0] center = current_state[i];
            reg [1:0] right = i == WIDTH-1 ? 2'b00 : current_state[i+1];

            
            if (left == 2'b11 && center == 2'b11 && right == 2'b11) begin
                q[i] = 2'b00;
            end else if (left == 2'b11 && center == 2'b11 && right == 2'b00) begin
                q[i] = 2'b11;
            end else if (left == 2'b11 && center == 2'b00 && right == 2'b11) begin
                q[i] = 2'b11;
            end else if (left == 2'b11 && center == 2'b00 && right == 2'b00) begin
                q[i] = 2'b00;
            end else if (left == 2'b00 && center == 2'b11 && right == 2'b11) begin
                q[i] = 2'b11;
            end else if (left == 2'b00 && center == 2'b11 && right == 2'b00) begin
                q[i] = 2'b11;
            end else if (left == 2'b00 && center == 2'b00 && right == 2'b11) begin
                q[i] = 2'b11;
            end else if (left == 2'b00 && center == 2'b00 && right == 2'b00) begin
                q[i] = 2'b00;
            end
        end
    end

endmodule
