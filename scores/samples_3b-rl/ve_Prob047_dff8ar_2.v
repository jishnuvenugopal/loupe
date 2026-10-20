
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire [7:0] d,
    output wire [7:0] q
);

    
    reg [7:0] dff0, dff1, dff2, dff3, dff4, dff5, dff6, dff7;
    reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset)
            q_reg <= 8'b0;
        else
            q_reg <= {dff7, dff6, dff5, dff4, dff3, dff2, dff1, dff0};
    end

    assign q = q_reg;

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff0 <= 1'b0;
        else
            dff0 <= d[0];
    end
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff1 <= 1'b0;
        else
            dff1 <= d[1];
    end
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff2 <= 1'b0;
        else
            dff2 <= d[2];
    end
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff3 <= 1'b0;
        else
            dff3 <= d[3];
    end
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff4 <= 1'b0;
        else
            dff4 <= d[4];
    end
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff5 <= 1'b0;
        else
            dff5 <= d[5];
    end
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff6 <= 1'b0;
        else
            dff6 <= d[6];
    end
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff7 <= 1'b0;
        else
            dff7 <= d[7];
    end

endmodule
