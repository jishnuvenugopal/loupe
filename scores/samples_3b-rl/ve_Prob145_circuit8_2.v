
module TopModule (
    input  wire clock,
    input  wire a,
    output reg  p,
    output reg  q
);

    
    wire prev_a;

    
    reg prev_p;

    
    reg prev_q;

    
    assign prev_a = a;

    
    always @(posedge clock) begin
        if (a)
            p <= ~p;
        else
            p <= 1'b0;
    end

    
    always @(posedge clock) begin
        if (a) begin
            if (~prev_p)
                q <= 1'b1;
            else
                q <= 1'b0;
        end else
            q <= 1'b0;
    end

    
    always @(posedge clock) begin
        prev_p <= p;
    end

    
    always @(posedge clock) begin
        prev_q <= q;
    end

endmodule
