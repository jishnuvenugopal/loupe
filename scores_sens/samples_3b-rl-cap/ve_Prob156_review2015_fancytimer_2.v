
module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire        data,
    output reg [3:0]   count,
    output reg         counting,
    output reg         done,
    input  wire        ack
);

    
    reg [3:0] delay;
    reg [3:0] state;
    reg [9:0] count1000;
 
    reg [3:0] count_remaining;
    reg       counting_done;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 4'b0000;
        end else begin
            case (state)
                4'b0000: begin 
                    if (data == 4'b1101) begin
                        state <= 4'b0001;
                    end else begin
                        state <= 4'b0000;
                    end
                end
                4'b0001: begin 
                    data <= data;
                    state <= 4'b0010;
                end
                4'b0010: begin 
                    delay <= {delay[2:0], data};
                    state <= 4'b0011;
                end
                4'b0011: begin 
                    if (count1000 == 0) begin
                        state <= 4'b0100;
                    end else begin
                        count1000 <= count1000 - 1;
                        count_remaining <= delay + 1;
                        count <= count_remaining;
                        counting <= 1'b1;
                        state <= 4'b0012;
                    end
                end
                4'b0012: begin 
                    if (count_remaining == 0) begin
                        state <= 4'b0011;
                    end else begin
                        count_remaining <= count_remaining - 1;
                        count <= count_remaining;
                        state <= 4'b0012;
                    end
                end
                4'b0100: begin 
                    state <= 4'b0101;
                end
                4'b0101: begin 
                    if (ack) begin
                        state <= 4'b0000;
                    end else begin
                        state <= 4'b0101;
                    end
                end
                default: state <= 4'b0000;
            endcase
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count1000 <= 10'd0;
            counting_done <= 1'b0;
        end else begin
            if (state == 4'b0011) begin
                count1000 <= 10'd1000;
            end else begin
                count1000 <= count1000 - 1;
                if (count1000 == 0) begin
                    counting_done <= 1'b1;
                end else begin
                    counting_done <= 1'b0;
                end
            end
        end
    end

    
    always @(*) begin
        if (state == 4'b0000) begin
            count = 4'd0;
            counting = 1'b0;
            done = 1'b0;
        end else if (state == 4'b0012) begin
            count = count_remaining;
            counting = 1'b1;
            done = 1'b0;
        end else if (state == 4'b0101) begin
            count = 4'd0;
            counting = 1'b0;
            done = 1'b1;
        end else begin
            count = 4'd0;
            counting = 1'b0;
            done = 1'b0;
        end
    end

endmodule
