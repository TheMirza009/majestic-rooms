export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.4"
  }
  public: {
    Tables: {
      accounts: {
        Row: {
          created_at: string | null
          created_by: string | null
          email: string | null
          id: string
          name: string
          picture_url: string | null
          public_data: Json
          updated_at: string | null
          updated_by: string | null
        }
        Insert: {
          created_at?: string | null
          created_by?: string | null
          email?: string | null
          id?: string
          name: string
          picture_url?: string | null
          public_data?: Json
          updated_at?: string | null
          updated_by?: string | null
        }
        Update: {
          created_at?: string | null
          created_by?: string | null
          email?: string | null
          id?: string
          name?: string
          picture_url?: string | null
          public_data?: Json
          updated_at?: string | null
          updated_by?: string | null
        }
        Relationships: []
      }
      blog_post: {
        Row: {
          created_at: string | null
          created_by: string | null
          id: number
          long_description: string | null
          short_description: string | null
          tags: string[] | null
          thumbnail: string | null
          title: string
        }
        Insert: {
          created_at?: string | null
          created_by?: string | null
          id?: number
          long_description?: string | null
          short_description?: string | null
          tags?: string[] | null
          thumbnail?: string | null
          title: string
        }
        Update: {
          created_at?: string | null
          created_by?: string | null
          id?: number
          long_description?: string | null
          short_description?: string | null
          tags?: string[] | null
          thumbnail?: string | null
          title?: string
        }
        Relationships: []
      }
      booking: {
        Row: {
          account_id: string | null
          booking_date: string | null
          booking_status:
            | Database["public"]["Enums"]["booking_status_enum"]
            | null
          check_in_date: string
          check_out_date: string
          discount: number | null
          gross_total: number | null
          guest_email: string | null
          guest_full_name: string | null
          guest_phone: string | null
          hotel_slug: string | null
          id: string
          net_total: number | null
          nights: number | null
          number_of_rooms: number | null
          promocode: string | null
          room_id: number | null
          special_request: string | null
        }
        Insert: {
          account_id?: string | null
          booking_date?: string | null
          booking_status?:
            | Database["public"]["Enums"]["booking_status_enum"]
            | null
          check_in_date: string
          check_out_date: string
          discount?: number | null
          gross_total?: number | null
          guest_email?: string | null
          guest_full_name?: string | null
          guest_phone?: string | null
          hotel_slug?: string | null
          id?: string
          net_total?: number | null
          nights?: number | null
          number_of_rooms?: number | null
          promocode?: string | null
          room_id?: number | null
          special_request?: string | null
        }
        Update: {
          account_id?: string | null
          booking_date?: string | null
          booking_status?:
            | Database["public"]["Enums"]["booking_status_enum"]
            | null
          check_in_date?: string
          check_out_date?: string
          discount?: number | null
          gross_total?: number | null
          guest_email?: string | null
          guest_full_name?: string | null
          guest_phone?: string | null
          hotel_slug?: string | null
          id?: string
          net_total?: number | null
          nights?: number | null
          number_of_rooms?: number | null
          promocode?: string | null
          room_id?: number | null
          special_request?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "booking_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "booking_hotel_slug_fkey"
            columns: ["hotel_slug"]
            isOneToOne: false
            referencedRelation: "hotel"
            referencedColumns: ["slug"]
          },
          {
            foreignKeyName: "booking_room_id_fkey"
            columns: ["room_id"]
            isOneToOne: false
            referencedRelation: "hotel_rooms"
            referencedColumns: ["id"]
          },
        ]
      }
      booking_detail: {
        Row: {
          booking_id: string | null
          discount: number | null
          gross_amount: number
          id: number
          includes_breakfast: boolean | null
          net_amount: number
          no_of_rooms: number | null
          room_id: number | null
          room_price: number
        }
        Insert: {
          booking_id?: string | null
          discount?: number | null
          gross_amount: number
          id?: number
          includes_breakfast?: boolean | null
          net_amount: number
          no_of_rooms?: number | null
          room_id?: number | null
          room_price: number
        }
        Update: {
          booking_id?: string | null
          discount?: number | null
          gross_amount?: number
          id?: number
          includes_breakfast?: boolean | null
          net_amount?: number
          no_of_rooms?: number | null
          room_id?: number | null
          room_price?: number
        }
        Relationships: [
          {
            foreignKeyName: "booking_detail_booking_id_fkey"
            columns: ["booking_id"]
            isOneToOne: false
            referencedRelation: "booking"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "booking_detail_room_id_fkey"
            columns: ["room_id"]
            isOneToOne: false
            referencedRelation: "hotel_rooms"
            referencedColumns: ["id"]
          },
        ]
      }
      facilities: {
        Row: {
          created_at: string | null
          icon: string | null
          id: string
          name: string
          slug: string
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          icon?: string | null
          id?: string
          name: string
          slug: string
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          icon?: string | null
          id?: string
          name?: string
          slug?: string
          updated_at?: string | null
        }
        Relationships: []
      }
      facility: {
        Row: {
          icon: string | null
          id: number
          name: string
          slug: string | null
        }
        Insert: {
          icon?: string | null
          id?: number
          name: string
          slug?: string | null
        }
        Update: {
          icon?: string | null
          id?: number
          name?: string
          slug?: string | null
        }
        Relationships: []
      }
      hotel: {
        Row: {
          address: string | null
          class: number | null
          coordinates: unknown
          description: string | null
          distance_from_haram: number | null
          email: string | null
          id: string
          is_active: boolean | null
          is_best_hotel: boolean | null
          land_line: string | null
          latitude: number | null
          liscense_no: string | null
          location_slug: string | null
          longitude: number | null
          name: string
          payment_policies: string | null
          phone_number: string | null
          serve_breakfast: boolean | null
          slug: string | null
          terms: string | null
        }
        Insert: {
          address?: string | null
          class?: number | null
          coordinates?: unknown
          description?: string | null
          distance_from_haram?: number | null
          email?: string | null
          id?: string
          is_active?: boolean | null
          is_best_hotel?: boolean | null
          land_line?: string | null
          latitude?: number | null
          liscense_no?: string | null
          location_slug?: string | null
          longitude?: number | null
          name: string
          payment_policies?: string | null
          phone_number?: string | null
          serve_breakfast?: boolean | null
          slug?: string | null
          terms?: string | null
        }
        Update: {
          address?: string | null
          class?: number | null
          coordinates?: unknown
          description?: string | null
          distance_from_haram?: number | null
          email?: string | null
          id?: string
          is_active?: boolean | null
          is_best_hotel?: boolean | null
          land_line?: string | null
          latitude?: number | null
          liscense_no?: string | null
          location_slug?: string | null
          longitude?: number | null
          name?: string
          payment_policies?: string | null
          phone_number?: string | null
          serve_breakfast?: boolean | null
          slug?: string | null
          terms?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "hotel_location_slug_fkey"
            columns: ["location_slug"]
            isOneToOne: false
            referencedRelation: "location"
            referencedColumns: ["slug"]
          },
        ]
      }
      hotel_facility: {
        Row: {
          facility_id: number
          hotel_id: string
        }
        Insert: {
          facility_id: number
          hotel_id: string
        }
        Update: {
          facility_id?: number
          hotel_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "hotel_facility_facility_id_fkey"
            columns: ["facility_id"]
            isOneToOne: false
            referencedRelation: "facility"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "hotel_facility_hotel_id_fkey"
            columns: ["hotel_id"]
            isOneToOne: false
            referencedRelation: "hotel"
            referencedColumns: ["id"]
          },
        ]
      }
      hotel_images: {
        Row: {
          description: string | null
          hotel_slug: string | null
          id: number
          sort_order: number | null
          url: string
        }
        Insert: {
          description?: string | null
          hotel_slug?: string | null
          id?: number
          sort_order?: number | null
          url: string
        }
        Update: {
          description?: string | null
          hotel_slug?: string | null
          id?: number
          sort_order?: number | null
          url?: string
        }
        Relationships: [
          {
            foreignKeyName: "hotel_images_hotel_slug_fkey"
            columns: ["hotel_slug"]
            isOneToOne: false
            referencedRelation: "hotel"
            referencedColumns: ["slug"]
          },
        ]
      }
      hotel_rooms: {
        Row: {
          beds: number | null
          city_view: boolean | null
          description: string | null
          hotel_slug: string | null
          id: number
          name: string | null
          price_per_night: number
          price_per_night_with_breakfast: number | null
          room_category_id: number | null
          room_number: string
          status: Database["public"]["Enums"]["room_status_enum"] | null
        }
        Insert: {
          beds?: number | null
          city_view?: boolean | null
          description?: string | null
          hotel_slug?: string | null
          id?: number
          name?: string | null
          price_per_night: number
          price_per_night_with_breakfast?: number | null
          room_category_id?: number | null
          room_number: string
          status?: Database["public"]["Enums"]["room_status_enum"] | null
        }
        Update: {
          beds?: number | null
          city_view?: boolean | null
          description?: string | null
          hotel_slug?: string | null
          id?: number
          name?: string | null
          price_per_night?: number
          price_per_night_with_breakfast?: number | null
          room_category_id?: number | null
          room_number?: string
          status?: Database["public"]["Enums"]["room_status_enum"] | null
        }
        Relationships: [
          {
            foreignKeyName: "hotel_rooms_hotel_slug_fkey"
            columns: ["hotel_slug"]
            isOneToOne: false
            referencedRelation: "hotel"
            referencedColumns: ["slug"]
          },
          {
            foreignKeyName: "hotel_rooms_room_category_id_fkey"
            columns: ["room_category_id"]
            isOneToOne: false
            referencedRelation: "room_category"
            referencedColumns: ["id"]
          },
        ]
      }
      location: {
        Row: {
          id: string
          name: string
          slug: string | null
          thumbnail: string | null
        }
        Insert: {
          id?: string
          name: string
          slug?: string | null
          thumbnail?: string | null
        }
        Update: {
          id?: string
          name?: string
          slug?: string | null
          thumbnail?: string | null
        }
        Relationships: []
      }
      payment: {
        Row: {
          amount: number
          booking_id: string | null
          id: number
          payment_date: string | null
          payment_method:
            | Database["public"]["Enums"]["payment_method_enum"]
            | null
          payment_status:
            | Database["public"]["Enums"]["payment_status_enum"]
            | null
        }
        Insert: {
          amount: number
          booking_id?: string | null
          id?: number
          payment_date?: string | null
          payment_method?:
            | Database["public"]["Enums"]["payment_method_enum"]
            | null
          payment_status?:
            | Database["public"]["Enums"]["payment_status_enum"]
            | null
        }
        Update: {
          amount?: number
          booking_id?: string | null
          id?: number
          payment_date?: string | null
          payment_method?:
            | Database["public"]["Enums"]["payment_method_enum"]
            | null
          payment_status?:
            | Database["public"]["Enums"]["payment_status_enum"]
            | null
        }
        Relationships: [
          {
            foreignKeyName: "payment_booking_id_fkey"
            columns: ["booking_id"]
            isOneToOne: false
            referencedRelation: "booking"
            referencedColumns: ["id"]
          },
        ]
      }
      promotion: {
        Row: {
          code: string
          description: string | null
          discount_percent: number | null
          hotel_id: string
          is_active: boolean | null
          valid_from: string | null
          valid_to: string | null
        }
        Insert: {
          code: string
          description?: string | null
          discount_percent?: number | null
          hotel_id: string
          is_active?: boolean | null
          valid_from?: string | null
          valid_to?: string | null
        }
        Update: {
          code?: string
          description?: string | null
          discount_percent?: number | null
          hotel_id?: string
          is_active?: boolean | null
          valid_from?: string | null
          valid_to?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "promotion_hotel_id_fkey"
            columns: ["hotel_id"]
            isOneToOne: false
            referencedRelation: "hotel"
            referencedColumns: ["id"]
          },
        ]
      }
      review: {
        Row: {
          booking_id: string | null
          feedback: string | null
          hotel_id: string | null
          id: number
          overall_rating: number | null
          reviewer_email: string | null
          reviewer_name: string
        }
        Insert: {
          booking_id?: string | null
          feedback?: string | null
          hotel_id?: string | null
          id?: number
          overall_rating?: number | null
          reviewer_email?: string | null
          reviewer_name: string
        }
        Update: {
          booking_id?: string | null
          feedback?: string | null
          hotel_id?: string | null
          id?: number
          overall_rating?: number | null
          reviewer_email?: string | null
          reviewer_name?: string
        }
        Relationships: [
          {
            foreignKeyName: "review_booking_id_fkey"
            columns: ["booking_id"]
            isOneToOne: false
            referencedRelation: "booking"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "review_hotel_id_fkey"
            columns: ["hotel_id"]
            isOneToOne: false
            referencedRelation: "hotel"
            referencedColumns: ["id"]
          },
        ]
      }
      review_detail_rating: {
        Row: {
          id: number
          rating: number | null
          review_id: number | null
          service: Database["public"]["Enums"]["service_rating_category"]
        }
        Insert: {
          id?: number
          rating?: number | null
          review_id?: number | null
          service: Database["public"]["Enums"]["service_rating_category"]
        }
        Update: {
          id?: number
          rating?: number | null
          review_id?: number | null
          service?: Database["public"]["Enums"]["service_rating_category"]
        }
        Relationships: [
          {
            foreignKeyName: "review_detail_rating_review_id_fkey"
            columns: ["review_id"]
            isOneToOne: false
            referencedRelation: "review"
            referencedColumns: ["id"]
          },
        ]
      }
      room_category: {
        Row: {
          id: number
          name: string
          slug: string | null
        }
        Insert: {
          id?: number
          name: string
          slug?: string | null
        }
        Update: {
          id?: number
          name?: string
          slug?: string | null
        }
        Relationships: []
      }
      room_images: {
        Row: {
          id: number
          room_id: number | null
          url: string
        }
        Insert: {
          id?: number
          room_id?: number | null
          url: string
        }
        Update: {
          id?: number
          room_id?: number | null
          url?: string
        }
        Relationships: [
          {
            foreignKeyName: "room_images_room_id_fkey"
            columns: ["room_id"]
            isOneToOne: false
            referencedRelation: "hotel_rooms"
            referencedColumns: ["id"]
          },
        ]
      }
      search_log: {
        Row: {
          check_in_date: string | null
          check_out_date: string | null
          id: number
          location_id: string | null
          promocode: string | null
          search_datetime: string | null
          user_id: string | null
        }
        Insert: {
          check_in_date?: string | null
          check_out_date?: string | null
          id?: number
          location_id?: string | null
          promocode?: string | null
          search_datetime?: string | null
          user_id?: string | null
        }
        Update: {
          check_in_date?: string | null
          check_out_date?: string | null
          id?: number
          location_id?: string | null
          promocode?: string | null
          search_datetime?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "search_log_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "location"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "search_log_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["id"]
          },
        ]
      }
      system_settings: {
        Row: {
          key: string
          updated_at: string | null
          value: Json
        }
        Insert: {
          key: string
          updated_at?: string | null
          value: Json
        }
        Update: {
          key?: string
          updated_at?: string | null
          value?: Json
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      booking_status_enum:
        | "PENDING"
        | "CONFIRMED"
        | "CANCELLED"
        | "CHECKED_IN"
        | "COMPLETED"
      payment_method_enum: "MASTER" | "VISA" | "MADA" | "APPLE_PAY"
      payment_status_enum: "PENDING" | "COMPLETED" | "FAILED"
      room_status_enum: "AVAILABLE" | "OCCUPIED" | "MAINTENANCE"
      service_rating_category:
        | "CLEANLINESS"
        | "STAFF"
        | "FOOD"
        | "VALUE_FOR_MONEY"
        | "COMFORT"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      booking_status_enum: [
        "PENDING",
        "CONFIRMED",
        "CANCELLED",
        "CHECKED_IN",
        "COMPLETED",
      ],
      payment_method_enum: ["MASTER", "VISA", "MADA", "APPLE_PAY"],
      payment_status_enum: ["PENDING", "COMPLETED", "FAILED"],
      room_status_enum: ["AVAILABLE", "OCCUPIED", "MAINTENANCE"],
      service_rating_category: [
        "CLEANLINESS",
        "STAFF",
        "FOOD",
        "VALUE_FOR_MONEY",
        "COMFORT",
      ],
    },
  },
} as const
