
module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

    
    reg prev_a;

    
    always @(posedge rst_n or negedge clk) begin
        if (!rst_n) begin
            rise <= 0;
            down <= 0;
        end
    end

    
    always @(posedge clk) begin
        if (a && !prev_a) begin
            rise <= 1;
        end else begin
            rise <= 0;
        end
    end

    
    always @(posedge clk) begin
        if (!a && prev_a) begin
            down <= 1;
        end else begin
            down <= 0;
        end
    end

    
    always @(posedge clk) begin
        prev_a <= a;
    end

endmodule
