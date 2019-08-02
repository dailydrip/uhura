class Array
  # [1, [2], [[3]], [[[4, 5], 6],7]].squash
  # [
  #     [0] "1",
  #     [1] "2",
  #     [2] "3",
  #     [3] "4",
  #     [4] "5",
  #     [5] "6",
  #     [6] "7"
  # ]
  def squash
    self.reject(&:blank?).flatten.join('ƶ').split('ƶ')
  end
end
