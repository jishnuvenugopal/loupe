
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    
    reg [3:0] state;
    reg [3:0] next_state;

    
    reg [3:0] shift_reg;

    
    reg [3:0] counter;

    
    reg [3:0] duration;

    
    wire start_detected;

    
    wire [3:0] delay_bits;
    wire delay_bits_valid;

    
    wire done_counting_detected;

    
    wire ack_detected;

    
    assign start_detected = (shift_reg == 4'b1101);

    
    assign delay_bits = shift_reg[3:0];
    assign delay_bits_valid = (shift_reg[7:4] == 4'b0000);

    
    assign done_counting_detected = done_counting;

    
    assign ack_detected = ack;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0000;
        end else begin
            state <= next_state;
        end
    end

    
    always @(*) begin
        case (state)
            4'b0000: begin 
                if (start_detected) begin
                    next_state = 4'b0001;
                end else begin
                    next_state = 4'b0000;
                end
            end
            4'b0001: begin 
                if (delay_bits_valid) begin
                    next_state = 4'b0010;
                end else begin
                    next_state = 4'b0001;
                end
            end
            4'b0010: begin 
                next_state = 4'b0011;
            end
            4'b0011: begin 
                if (done_counting_detected) begin
                    next_state = 4'b0100;
                end else begin
                    next_state = 4'b0011;
                end
            end
            4'b0100: begin 
                if (ack_detected) begin
                    next_state = 4'b0000;
                end else begin
                    next_state = 4'b0100;
                end
            end
            default: begin
                next_state = 4'b0000;
            end
        endcase
    end

    
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else begin
            if (state == 4'b0001) begin
                shift_reg <= {shift_reg[2:0], data};
            end else if (state == 4'b0002) begin
                shift_reg <= {shift_reg[2:0], data};
            end else if (state == 4'b0003) begin
                shift_reg <= {shift_reg[2:0], data};
            end else if (state == 4'b0004) begin
                shift_reg <= {shift_reg[2:0], data};
            end else begin
                shift_reg <= shift_reg;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0000;
        end else begin
            if (state == 4'b0001) begin
                counter <= 4'b0000;
            end else if (state == 4'b0010) begin
                counter <= counter + 1'b1;
            end else begin
                counter <= counter;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            duration <= 4'b0000;
        end else begin
            if (state == 4'b0001) begin
                duration <= 4'b0000;
            end else if (state == 4'b0010) begin
                duration <= 4'b0000;
            end else if (state == 4'b0011) begin
                duration <= delay_bits;
            end else begin
                duration <= duration;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
        end else begin
            if (state == 4'b0001) begin
                shift_ena <= 1'b0;
            end else if (state == 4'b0002) begin
                shift_ena <= 1'b0;
            end else if (state == 4'b0003) begin
                shift_ena <= 1'b0;
            end else if (state == 4'b0004) begin
                shift_ena <= 1'b0;
            end else if (state == 4'b0010) begin
                shift_ena <= 1'b1;
            end else begin
                shift_ena <= shift_ena;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
        end else begin
            if (state == 4'b0001) begin
                counting <= 1'b0;
            end else if (state == 4'b0010) begin
                counting <= 1'b0;
            end else if (state == 4'b0011) begin
                counting <= 1'b1;
            end else begin
                counting <= counting;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            if (state == 4'b0001) begin
                done <= 1'b0;
            end else if (state == 4'b0010) begin
                done <= 1'b0;
            end else if (state == 4'b0011) begin
                done <= 1'b0;
            end else if (state == 4'b0100) begin
                done <= 1'b1;
            end else begin
                done <= done;
            end
        end
    end

endmodule
