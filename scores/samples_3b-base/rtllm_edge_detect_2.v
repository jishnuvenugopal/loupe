
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
        if (!rst_n) begin
            prev_a <= a;
        end else begin
            if (a && !prev_a) begin
                rise <= 1;
                down <= 0;
            end else begin
                rise <= 0;
                down <= 0;
            end
        end
    end

    
    always @(posedge clk) begin
        if (!rst_n) begin
            prev_a <= a;
        end else begin
            if (!a && prev_a) begin
                rise <= 0;
                down <= 1;
            end else begin
                rise <= 0;
                down <= 0;
            end
        end
    end

endmodule
