
module TopModule (
    input  clk,
    input  reset,
    input  [7:0] d,
    output [7:0] q
);

    
    reg [7:0] dff0, dff1, dff2, dff3, dff4, dff5, dff6, dff7;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dff0 <= 8'b0;
        end else begin
            dff0 <= d;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dff1 <= 8'b0;
        end else begin
            dff1 <= dff0;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dff2 <= 8'b0;
        end else begin
            dff2 <= dff1;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dff3 <= 8'b0;
        end else begin
            dff3 <= dff2;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dff4 <= 8'b0;
        end else begin
            dff4 <= dff3;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dff5 <= 8'b0;
        end else begin
            dff5 <= dff4;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dff6 <= 8'b0;
        end else begin
            dff6 <= dff5;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dff7 <= 8'b0;
        end else begin
            dff7 <= dff6;
        end
    end

    
    assign q = dff7;

endmodule
