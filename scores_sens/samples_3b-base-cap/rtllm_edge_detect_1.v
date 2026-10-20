
module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

    
    reg [1:0] a_prev;

    
    always @(posedge rst_n) begin
        rise <= 0;
        down <= 0;
    end

    
    always @(posedge clk) begin
        if (!rst_n) begin
            rise <= 0;
        end else if (a_prev == 0 && a == 1) begin
            rise <= 1;
        end else begin
            rise <= 0;
        end
    end

    
    always @(posedge clk) begin
        if (!rst_n) begin
            down <= 0;
        end else if (a_prev == 1 && a == 0) begin
            down <= 1;
        end else begin
            down <= 0;
        end
    end

    
    always @(posedge clk) begin
        a_prev <= {a_prev[0], a};
    end

endmodule
