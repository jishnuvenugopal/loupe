
module TopModule (clk, reset, shift_ena);
  input clk;
  input reset;
  output reg shift_ena;

  
  localparam IDLE = 2'b00;
  localparam ENABLE_1 = 2'b01;
  localparam ENABLE_2 = 2'b10;
  localparam ENABLE_4 = 2'b11;

  
  reg [1:0] state;

  
  reg [1:0] count;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      count <= 2'b00;
      shift_ena <= 1'b1;
  
    end else begin
      shift_ena <= 1'b0;
  

      case (state)
        IDLE: begin
          if (count == 2'b00) begin
            shift_ena <= 1'b1;
  
          end else if (count == 2'b11) begin
            count <= 2'b00;
  
          end else begin
            count <= count + 1;
  
          end
        end

        ENABLE_1, ENABLE_2, ENABLE_3, ENABLE_4: begin
          shift_ena <= 1'b1;
  
          count <= count + 1;
  

          if (count == 2'b11) begin  
            state <= IDLE;
            count <= 2'b00;
          end
        end

        default: state <= IDLE;
  
      endcase

      
      case (state)
        IDLE: begin
          if (shift_ena == 1'b1) begin
            state <= ENABLE_1;
          end
        end

        ENABLE_1: state <= ENABLE_2;
        ENABLE_2: state <= ENABLE_3;
        ENABLE_3: state <= ENABLE_4;
        IDLE: ;
  
      endcase
    end
  end

endmodule
