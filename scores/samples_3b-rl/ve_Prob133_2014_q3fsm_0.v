
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire s,
    input  wire w,
    output reg  z
);

    
    reg [1:0] state;

    
    reg [1:0] count;

    
    reg z_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            count <= 2'b00;
            z_reg <= 1'b0;
        end else begin
            case (state)
                2'b00: begin 
                    if (s == 1'b1) begin
                        state <= 2'b01;
                    end else begin
                        state <= 2'b00;
                    end
                end
                2'b01: begin 
                    if (count == 3'd3) begin
                        state <= 2'b00;
                        count <= 2'b00;
                        z_reg <= 1'b0;
                    end else begin
                        if (w == 1'b1) begin
                            count <= count + 2'd1;
                        end
                        if (count == 2'd2) begin
                            if (w == 1'b1) begin
                                z_reg <= 1'b1;
                            end else begin
                                z_reg <= 1'b0;
                            end
                        end
                    end
                end
                default: state <= 2'b00;
            endcase
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            z <= 1'b0;
        end else begin
            z <= z_reg;
        end
    end

endmodule
