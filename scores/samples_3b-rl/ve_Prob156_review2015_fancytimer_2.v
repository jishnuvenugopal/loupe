
module TopModule (
    input        clk,
    input        reset,
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    
    reg [3:0] delay;
         
    reg [3:0] state;
         
    reg       search;
        
    reg       start;
         
    reg       counting_done;
 

    
    parameter IDLE = 4'd0;
    parameter SEARCH = 4'd1;
    parameter DELAY = 4'd2;
    parameter COUNTING = 4'd3;
    parameter DONE = 4'd4;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            search <= 1'b0;
            start <= 1'b0;
            count <= 4'd0;
            delay <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count_done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data == 4'b1101) begin
                        state <= SEARCH;
                    end else begin
                        state <= IDLE;
                    end
                end
                SEARCH: begin
                    if (data == 4'b1101) begin
                        state <= DELAY;
                        search <= 1'b0;
                    end else begin
                        state <= SEARCH;
                        search <= 1'b1;
                    end
                end
                DELAY: begin
                    if (data == 4'b1101) begin
                        state <= DELAY;
                    end else begin
                        state <= DELAY;
                        delay <= delay + 1'b1;
                    end
                end
                COUNTING: begin
                    if (count == delay) begin
                        state <= DONE;
                        count_done <= 1'b1;
                    end else begin
                        state <= COUNTING;
                        count <= count + 1'b1;
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        search <= 1'b0;
                        start <= 1'b0;
                        count <= 4'd0;
                        delay <= 4'd0;
                        counting <= 1'b0;
                        done <= 1'b0;
                        count_done <= 1'b0;
                    end else begin
                        state <= DONE;
                        search <= 1'b0;
                        start <= 1'b0;
                        count <= 4'd0;
                        delay <= 4'd0;
                        counting <= 1'b0;
                        done <= 1'b1;
                        count_done <= 1'b0;
                    end
                end
                default: begin
                    state <= IDLE;
                    search <= 1'b0;
                    start <= 1'b0;
                    count <= 4'd0;
                    delay <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count_done <= 1'b0;
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0;
            counting <= 1'b0;
        end else begin
            if (state == COUNTING) begin
                counting <= 1'b1;
            end else begin
                counting <= 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0;
        end else begin
            if (state == COUNTING) begin
                count <= count + 1'b1;
            end else begin
                count <= 4'd0;
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            if (state == DONE) begin
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule
