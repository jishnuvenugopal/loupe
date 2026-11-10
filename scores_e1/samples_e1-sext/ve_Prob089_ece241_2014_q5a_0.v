
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    
    reg [1:0] state;
    reg [7:0] current_input;
    reg [7:0] complemented_output;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            current_input <= 8'b00000000;
            complemented_output <= 8'b00000000;
        end else begin
            case (state)
                2'b00: begin
                    
                    if (x) begin
                        state <= 2'b01;
                        current_input <= x;
                    end
                end
                2'b01: begin
                    
                    complemented_output = ~current_input;
                    state <= 2'b00;
                end
            endcase
        end
    end

    
    assign z = complemented_output;

endmodule
