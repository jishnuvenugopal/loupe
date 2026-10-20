
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire [7:0] d,
    output reg  [7:0] q
);

    
    reg [7:0] dff_array;

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff_array[0] <= 1'b0;
        else
            dff_array[0] <= d[0];
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff_array[1] <= 1'b0;
        else
            dff_array[1] <= d[1];
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff_array[2] <= 1'b0;
        else
            dff_array[2] <= d[2];
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff_array[3] <= 1'b0;
        else
            dff_array[3] <= d[3];
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff_array[4] <= 1'b0;
        else
            dff_array[4] <= d[4];
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff_array[5] <= 1'b0;
        else
            dff_array[5] <= d[5];
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff_array[6] <= 1'b0;
        else
            dff_array[6] <= d[6];
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            dff_array[7] <= 1'b0;
        else
            dff_array[7] <= d[7];
    end

    
    assign q = dff_array;

endmodule
