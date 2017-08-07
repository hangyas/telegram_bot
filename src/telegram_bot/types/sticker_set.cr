require "json"

module TelegramBot
  class StickerSet
    JSON.mapping({
      name:           String,
      title:          String,
      contains_masks: Bool,
      stickers:       Array(Sticker),
    })
  end
end
