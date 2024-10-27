class Radix4BoothMultiplier:
    def __init__(self):
        self.reset()

    def reset(self):
        self.out = 0
        self.c = 0
        self.pp = 0  # Partial products
        self.spp = 0  # Shifted partial products
        self.prod = 0
        self.i = 0
        self.j = 0
        self.flag = False
        self.temp = 0

    def two_complement(self, x):
        return (~x + 1) & 0xFFFF  # Ensure it's a 16-bit value

    def multiply(self, x, y):
        # Initialize values on first call
        if not self.flag:
            self.c = (y & 0xFFFF) | (y & 0xFFFF) << 1  # Initializing c with y
            self.flag = True

        while self.i < 8:
            # Extract bits for c based on i
            c_bits = (self.c >> (2 * self.i)) & 0b111
            if c_bits in [0b000, 0b111]:
                # Do nothing for these cases
                self.i += 1
                continue
            
            elif c_bits in [0b001, 0b010]:
                # Generate partial product
                pp = (self.two_complement(x) if c_bits == 0b001 else x)
                if self.i == 1:
                    self.prod += pp
                else:
                    self.temp = pp
                    self.j = (self.i - 1) << 1
                    self.spp = pp << self.j  # Shift partial product
                    self.prod += self.spp      # Add shifted partial product

            # Move to the next iteration
            self.i += 1
        
        # Final output after all iterations are complete
        self.out = self.prod

# Example usage:
if __name__ == "__main__":
    multiplier = Radix4BoothMultiplier()
    x = int(input("Enter first number (x): "))
    y = int(input("Enter second number (y): "))
    
    multiplier.multiply(x, y)
    print(f"Product of {x} and {y} is: {multiplier.out}")