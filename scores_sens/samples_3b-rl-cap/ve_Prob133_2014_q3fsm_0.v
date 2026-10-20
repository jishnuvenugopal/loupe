
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire s,
    input  wire w,
    output reg  z
);

    
    
    
    reg [1:0] state;
    
    reg [2:0] count;
    
    reg z_reg;

    always @(posedge clk) begin
        if (reset) begin
            state  <= 2'b00;
            count  <= 3'b000;
            z_reg  <= 1'b0;
        end else begin
            case (state)
                2'b00: begin 
                    if (s) begin
                        state <= 2'b01;
 
                    end
                end
                2'b01: begin 
                    if (count == 3'd3) begin
                        
                        if (count[2] + count[1] + count[0] == 2'd2) begin
                            z_reg <= 1'b1;
                        end else begin
                            z_reg <= 1'b0;
                        end
                        state <= 2'b00;
 
                        count <= 3'd0;
                    end else begin
                        if (w) begin
                            count <= count + 3'd1;
                        end else begin
                            count <= 3'd0;
                        end
                        state <= 2'b01;
                    end
                end
                default: begin
                    state <= 2'b00;
                    count <= 3'd0;
                    z_reg <= 1'b0;
                end
            endcase
        end
    end

    assign z = z_reg;

endmodule
