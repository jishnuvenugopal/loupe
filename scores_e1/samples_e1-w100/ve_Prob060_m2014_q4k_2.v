
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
        data <= 4'b0000;
    end

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            counter <= 4'b0000;
            data <= 4'b0000;
        end else begin
            if (counter == 4'b0001) begin
                counter <= 4'b0000;
                data <= data << 1;
                data[0] <= in;
            end else if (counter == 4'b0010) begin
                counter <= 4'b0001;
                data <= data << 1;
                data[0] <= in;
            end else if (counter == 4'b0011) begin
                counter <= 4'b0010;
                data <= data << 1;
                data[0] <= in;
            end else if (counter == 4'b0100) begin
                counter <= 4'b0011;
                data <= data << 1;
                data[0] <= in;
            end
        end
    end

    
    always @(*) begin
        out <= q3;
    end

endmodule
