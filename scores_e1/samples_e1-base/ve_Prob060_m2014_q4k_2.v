
module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    
    reg [3:0] counter;
    reg [3:0] data;

    
    reg q0, q1, q2, q3;

    
    initial begin
        counter <= 4'b0000;
        q0 <= 1'b0;
        q1 <= 1'b0;
        q2 <= 1'b0;
        q3 <= 1'b0;
    end

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            counter <= 4'b0000;
            q0 <= 1'b0;
            q1 <= 1'b0;
            q2 <= 1'b0;
            q3 <= 1'b0;
        end else begin
            if (counter == 4'b0001) begin
                q0 <= q1;
                q1 <= q2;
                q2 <= q3;
                q3 <= in;
                counter <= 4'b0000;
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end

    
    assign out = data;

endmodule
