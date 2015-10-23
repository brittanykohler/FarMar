module FarMar
  class Vendor
    attr_reader :id, :name, :num_employees, :market_id

    def initialize(id, name, num_employees, market_id)
      @id = id
      @name = name
      @num_employees = num_employees
      @market_id = market_id
    end

    def self.all
      if @all_vendors.nil? || @all_vendors.empty?
        @all_vendors =CSV.read("support/vendors.csv").map do |line|
          FarMar::Vendor.new(line[0].to_i, line[1], line[2].to_i, line[3].to_i)
        end
      end
      return @all_vendors
    end

    def self.find(id)
      match = CSV.open("support/vendors.csv").find { |n| n[0].to_i == id}
      return FarMar::Vendor.new(match[0].to_i, match[1], match[2].to_i, match[3].to_i)
    end

    def market
      return FarMar::Market.all.find {|market| market.id == @market_id}
    end

    def products
      return FarMar::Product.all.find_all {|product| product.vendor_id == @id}
    end

    def sales
      return FarMar::Sale.all.find_all {|sale| sale.vendor_id == @id}
    end

    def revenue(date = nil)
      date = Date.parse(date) if !date.nil?
      total_revenue = 0
      sales.each do |sale|
        if sale.purchase_time.to_date == date || date.nil?
          total_revenue += sale.amount
        end
      end
      return total_revenue
    end

    def self.by_market(market_id)
      market = FarMar::Market.find(market_id)
      return market.vendors
    end

    def self.most_revenue(n)
      return FarMar::Vendor.all.max_by(n) {|vendor| vendor.revenue}
    end

    def self.most_items(n)
      return FarMar::Vendor.all.max_by(n) {|vendor| vendor.products.length}
    end

    def self.revenue(date)
      date = Date.parse(date)
      total_revenue = 0
      FarMar::Sale.all.each do |sale|
        if sale.purchase_time.to_date == date
          total_revenue += sale.amount
        end
      end
      return total_revenue
    end
  end
end
