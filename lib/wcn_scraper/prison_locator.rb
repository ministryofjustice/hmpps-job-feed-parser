module WcnScraper
  class PrisonLocator
    class PrisonNotFoundError < StandardError
    end

    PRISONS = [
      { name: 'HMP Berwyn', lat: 53.036418, lng: -2.9292142 },
      { name: 'HMP Brixton', lat: 51.4516617, lng: -0.1250917 },
      { name: 'HMP Bure', lat: 52.759454, lng: 1.3458199 },
      { name: 'HMP Cardiff', lat: 51.4810689, lng: -3.1683326 },
      { name: 'HMP Channings Wood', lat: 50.5104924, lng: -3.6518204 },
      { name: 'HMP Chelmsford', lat: 51.7361324, lng: 0.4860732999999999 },
      { name: 'HMP Coldingley', lat: 51.3217467, lng: -0.6432669 },
      { name: 'HMP Dartmoor', lat: 50.5495271, lng: -3.9963275 },
      { name: 'HMP Eastwood Park', lat: 51.63504709999999, lng: -2.468383 },
      { name: 'HMP Erlestoke', lat: 51.2833485, lng: -2.0430271 },
      { name: 'HMP Featherstone', lat: 52.6473483, lng: -2.1098351 },
      { name: 'HMP Grendon', lat: 51.8931365, lng: -1.0072932 },
      { name: 'HMP Guys Marsh', lat: 50.9847775, lng: -2.2215698 },
      { name: 'HMP Haverigg', lat: 54.2022592, lng: -3.3125602 },
      { name: 'HMP Hewell', lat: 52.3246695, lng: -1.9870964 },
      { name: 'HMP High Down', lat: 51.3357233, lng: -0.1890383 },
      { name: 'HMP Highpoint', lat: 52.136974, lng: 0.510659 },
      { name: 'HMP Hollesley Bay', lat: 52.051042, lng: 1.451328 },
      { name: 'HMP Humber', lat: 53.7693399, lng: -0.6410579 },
      { name: 'HMP Huntercombe', lat: 51.5874, lng: -1.0183 },
      { name: 'HMP Kirkham', lat: 53.774924, lng: -2.8731828 },
      { name: 'HMP Leicester', lat: 52.6274509, lng: -1.131901 },
      { name: 'HMP Leyhill', lat: 51.62803419999999, lng: -2.4367766 },
      { name: 'HMP Lincoln', lat: 53.234813, lng: -0.517210 },
      { name: 'IRC Morton Hall', lat: 53.167904, lng: -0.689086 },
      { name: 'HMP Littlehey', lat: 52.2805913, lng: -0.3122374 },
      { name: 'HMP Long Lartin', lat: 52.108459, lng: -1.8540072 },
      { name: 'HMP Low Newton', lat: 54.8064867, lng: -1.549427 },
      { name: 'HMP Maidstone', lat: 51.2793606, lng: 0.5237286 },
      { name: 'HMP Norwich', lat: 52.6369762, lng: 1.3179051 },
      { name: 'HMP Onley', lat: 52.3269943, lng: -1.2465741 },
      { name: 'HMP Ranby', lat: 53.3200826, lng: -0.9961172 },
      { name: 'HMP Stocken', lat: 52.7469327, lng: -0.5821626999999999 },
      { name: 'HMP Swaleside', lat: 51.3929227, lng: 0.8536864000000001 },
      { name: 'HMP The Mount', lat: 51.72473859999999, lng: -0.5410677 },
      { name: 'HMP Usk/Prescoed', lat: 51.6856926, lng: -2.9414967 },
      { name: 'HMP Wandsworth', lat: 51.4500051, lng: -0.1775711 },
      { name: 'HMP Wayland', lat: 52.5538889, lng: 0.8580555999999999 },
      { name: 'HMP Whatton', lat: 52.9472902, lng: -0.9116372 },
      { name: 'HMP Whitemoor', lat: 52.57534589999999, lng: 0.0811047 },
      { name: 'HMP Winchester', lat: 51.0625986, lng: -1.3279811 },
      { name: 'HMP Woodhill', lat: 52.0143898, lng: -0.8083142 },
      { name: 'HMP/YOI Bedford', lat: 52.1389661, lng: -0.4696008999999999 },
      { name: 'HMP/YOI Downview', lat: 51.3384631, lng: -0.1880442 },
      { name: 'HMP/YOI Drake Hall', lat: 52.87726, lng: -2.2425361 },
      { name: 'HMP/YOI Foston Hall', lat: 52.8822614, lng: -1.7253463 },
      { name: 'HMP/YOI Isis', lat: 51.4976997, lng: 0.09784160000000001 },
      { name: 'HMP/YOI Isle of Wight', lat: 50.713196, lng: -1.3076464 },
      { name: 'HMP/YOI Lewes', lat: 50.8722285, lng: -0.005117099999999999 },
      { name: 'HMP/YOI Send', lat: 51.2716941, lng: -0.4908906 },
      { name: 'HMP/YOI Wormwood Scrubs', lat: 51.5169637, lng: -0.2403418 },
      { name: 'HMYOI Aylesbury', lat: 51.8225809, lng: -0.8016525999999999 },
      { name: 'HMYOI Cookham Wood', lat: 51.3663986, lng: 0.4942465 },
      { name: 'HMYOI Deerbolt', lat: 54.5432115, lng: -1.9367631 },
      { name: 'HMYOI Feltham', lat: 51.4415566, lng: -0.4340565 },
      { name: 'HMYOI Portland & IRC Verne', lat: 50.5497794, lng: -2.4219912 },
      { name: 'HMYOI Stoke Heath', lat: 52.8688371, lng: -2.5218096 },
      { name: 'HMYOI Swinfen Hall', lat: 52.6525736, lng: -1.8066018 }
    ].freeze

    def self.find(prison_name)
      prison = PRISONS.find { |p| p[:name] == prison_name }
      raise self::PrisonNotFoundError if prison.nil?
      Prison.new(prison)
    end
  end
end
