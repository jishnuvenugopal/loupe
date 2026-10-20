
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    
    reg [2:0] x_reg;
    
    reg [1:0] y_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            
            f <= 1'b1;
            g <= 1'b0;
            x_reg <= 3'b000;
            y_reg <= 2'b00;
        end else begin
            
            f <= 1'b0;

            
            x_reg <= {x_reg[1:0], x};

            
            if (x_reg == 3'b101) begin
                g <= 1'b1;
            end else begin
                g <= 1'b0;
            end

            
            y_reg <= {y_reg[0], y};

            
            if (g) begin
                if (y_reg == 2'b11) begin
                    
                end else begin
                    g <= 1'b0;
                end
            end
        end
    end

endmodule
