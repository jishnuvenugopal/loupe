
module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out_sop,
    output reg out_pos
);

    
    reg [3:0] sop = 4'b0000;

    
    reg [3:0] pos = 4'b0000;

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            sop = 4'b0000;
            pos = 4'b0000;
        end else begin
            if (a || b || c || d) begin
                sop = sop | 4'b1111;
            end
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            pos = 4'b0000;
        end else begin
            if (a && b && c && d) begin
                pos = pos | 4'b1111;
            end
        end
    end

    
    assign out_sop = sop;

    
    assign out_pos = pos;

endmodule
