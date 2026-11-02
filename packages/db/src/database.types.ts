export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[]

export type Database = {
  public: {
    Tables: {
      amenities: {
        Row: {
          icon: string | null
          id: string
          key: string
          sort_order: number
        }
        ComputedFields: never
        Insert: {
          icon?: string | null
          id?: string
          key: string
          sort_order?: number
        }
        Update: {
          icon?: string | null
          id?: string
          key?: string
          sort_order?: number
        }
        Relationships: []
      }
      amenity_translations: {
        Row: {
          amenity_id: string
          locale: string
          name: string
        }
        ComputedFields: never
        Insert: {
          amenity_id: string
          locale: string
          name: string
        }
        Update: {
          amenity_id?: string
          locale?: string
          name?: string
        }
        Relationships: [
          {
            foreignKeyName: 'amenity_translations_amenity_id_fkey'
            columns: ['amenity_id']
            isOneToOne: false
            referencedRelation: 'amenities'
            referencedColumns: ['id']
          },
          {
            foreignKeyName: 'amenity_translations_locale_fkey'
            columns: ['locale']
            isOneToOne: false
            referencedRelation: 'locales'
            referencedColumns: ['code']
          },
        ]
      }
      audit_log: {
        Row: {
          action: string
          actor_id: string | null
          created_at: string
          id: number
          new_data: Json | null
          old_data: Json | null
          record_id: string | null
          table_name: string
        }
        ComputedFields: never
        Insert: {
          action: string
          actor_id?: string | null
          created_at?: string
          id?: never
          new_data?: Json | null
          old_data?: Json | null
          record_id?: string | null
          table_name: string
        }
        Update: {
          action?: string
          actor_id?: string | null
          created_at?: string
          id?: never
          new_data?: Json | null
          old_data?: Json | null
          record_id?: string | null
          table_name?: string
        }
        Relationships: []
      }
      exchange_rates: {
        Row: {
          base: string
          quote: string
          rate: number
          updated_at: string
          updated_by: string | null
        }
        ComputedFields: never
        Insert: {
          base: string
          quote: string
          rate: number
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          base?: string
          quote?: string
          rate?: number
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'exchange_rates_updated_by_fkey'
            columns: ['updated_by']
            isOneToOne: false
            referencedRelation: 'profiles'
            referencedColumns: ['id']
          },
        ]
      }
      investment_fact_translations: {
        Row: {
          body: string | null
          fact_id: string
          label: string
          locale: string
        }
        ComputedFields: never
        Insert: {
          body?: string | null
          fact_id: string
          label: string
          locale: string
        }
        Update: {
          body?: string | null
          fact_id?: string
          label?: string
          locale?: string
        }
        Relationships: [
          {
            foreignKeyName: 'investment_fact_translations_fact_id_fkey'
            columns: ['fact_id']
            isOneToOne: false
            referencedRelation: 'investment_facts'
            referencedColumns: ['id']
          },
          {
            foreignKeyName: 'investment_fact_translations_locale_fkey'
            columns: ['locale']
            isOneToOne: false
            referencedRelation: 'locales'
            referencedColumns: ['code']
          },
        ]
      }
      investment_facts: {
        Row: {
          as_of: string
          created_at: string
          id: string
          is_published: boolean
          key: string
          sort_order: number
          source_url: string
          updated_at: string
          value: string
        }
        ComputedFields: never
        Insert: {
          as_of: string
          created_at?: string
          id?: string
          is_published?: boolean
          key: string
          sort_order?: number
          source_url: string
          updated_at?: string
          value: string
        }
        Update: {
          as_of?: string
          created_at?: string
          id?: string
          is_published?: boolean
          key?: string
          sort_order?: number
          source_url?: string
          updated_at?: string
          value?: string
        }
        Relationships: []
      }
      lead_events: {
        Row: {
          actor_id: string | null
          created_at: string
          from_stage: Database['public']['Enums']['lead_stage'] | null
          id: number
          lead_id: string
          note: string | null
          remind_at: string | null
          to_stage: Database['public']['Enums']['lead_stage'] | null
          type: Database['public']['Enums']['lead_event_type']
        }
        ComputedFields: never
        Insert: {
          actor_id?: string | null
          created_at?: string
          from_stage?: Database['public']['Enums']['lead_stage'] | null
          id?: never
          lead_id: string
          note?: string | null
          remind_at?: string | null
          to_stage?: Database['public']['Enums']['lead_stage'] | null
          type: Database['public']['Enums']['lead_event_type']
        }
        Update: {
          actor_id?: string | null
          created_at?: string
          from_stage?: Database['public']['Enums']['lead_stage'] | null
          id?: never
          lead_id?: string
          note?: string | null
          remind_at?: string | null
          to_stage?: Database['public']['Enums']['lead_stage'] | null
          type?: Database['public']['Enums']['lead_event_type']
        }
        Relationships: [
          {
            foreignKeyName: 'lead_events_actor_id_fkey'
            columns: ['actor_id']
            isOneToOne: false
            referencedRelation: 'profiles'
            referencedColumns: ['id']
          },
          {
            foreignKeyName: 'lead_events_lead_id_fkey'
            columns: ['lead_id']
            isOneToOne: false
            referencedRelation: 'leads'
            referencedColumns: ['id']
          },
        ]
      }
      leads: {
        Row: {
          assigned_to: string | null
          closed_at: string | null
          closed_currency: string | null
          closed_price: number | null
          consent_marketing: boolean
          consent_privacy_at: string
          country: string | null
          created_at: string
          email: string
          first_response_at: string | null
          full_name: string
          goal: Database['public']['Enums']['lead_goal'] | null
          id: string
          interest: Database['public']['Enums']['lead_interest'] | null
          locale: string
          lost_reason: string | null
          message: string | null
          phone: string
          preferred_channel: Database['public']['Enums']['contact_channel'] | null
          preferred_date: string | null
          preferred_slot: string | null
          property_id: string | null
          residency_interest: boolean
          source: Database['public']['Enums']['lead_source']
          stage: Database['public']['Enums']['lead_stage']
          timezone: string | null
          updated_at: string
        }
        ComputedFields: never
        Insert: {
          assigned_to?: string | null
          closed_at?: string | null
          closed_currency?: string | null
          closed_price?: number | null
          consent_marketing?: boolean
          consent_privacy_at: string
          country?: string | null
          created_at?: string
          email: string
          first_response_at?: string | null
          full_name: string
          goal?: Database['public']['Enums']['lead_goal'] | null
          id?: string
          interest?: Database['public']['Enums']['lead_interest'] | null
          locale: string
          lost_reason?: string | null
          message?: string | null
          phone: string
          preferred_channel?: Database['public']['Enums']['contact_channel'] | null
          preferred_date?: string | null
          preferred_slot?: string | null
          property_id?: string | null
          residency_interest?: boolean
          source: Database['public']['Enums']['lead_source']
          stage?: Database['public']['Enums']['lead_stage']
          timezone?: string | null
          updated_at?: string
        }
        Update: {
          assigned_to?: string | null
          closed_at?: string | null
          closed_currency?: string | null
          closed_price?: number | null
          consent_marketing?: boolean
          consent_privacy_at?: string
          country?: string | null
          created_at?: string
          email?: string
          first_response_at?: string | null
          full_name?: string
          goal?: Database['public']['Enums']['lead_goal'] | null
          id?: string
          interest?: Database['public']['Enums']['lead_interest'] | null
          locale?: string
          lost_reason?: string | null
          message?: string | null
          phone?: string
          preferred_channel?: Database['public']['Enums']['contact_channel'] | null
          preferred_date?: string | null
          preferred_slot?: string | null
          property_id?: string | null
          residency_interest?: boolean
          source?: Database['public']['Enums']['lead_source']
          stage?: Database['public']['Enums']['lead_stage']
          timezone?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: 'leads_assigned_to_fkey'
            columns: ['assigned_to']
            isOneToOne: false
            referencedRelation: 'profiles'
            referencedColumns: ['id']
          },
          {
            foreignKeyName: 'leads_locale_fkey'
            columns: ['locale']
            isOneToOne: false
            referencedRelation: 'locales'
            referencedColumns: ['code']
          },
          {
            foreignKeyName: 'leads_property_id_fkey'
            columns: ['property_id']
            isOneToOne: false
            referencedRelation: 'properties'
            referencedColumns: ['id']
          },
        ]
      }
      locales: {
        Row: {
          code: string
          is_default: boolean
          is_enabled: boolean
          is_required: boolean
          name: string
          native_name: string
          sort_order: number
        }
        ComputedFields: never
        Insert: {
          code: string
          is_default?: boolean
          is_enabled?: boolean
          is_required?: boolean
          name: string
          native_name: string
          sort_order?: number
        }
        Update: {
          code?: string
          is_default?: boolean
          is_enabled?: boolean
          is_required?: boolean
          name?: string
          native_name?: string
          sort_order?: number
        }
        Relationships: []
      }
      profiles: {
        Row: {
          avatar_path: string | null
          created_at: string
          email: string | null
          full_name: string
          id: string
          is_active: boolean
          phone: string | null
          role: Database['public']['Enums']['app_role']
          updated_at: string
          whatsapp: string | null
        }
        ComputedFields: never
        Insert: {
          avatar_path?: string | null
          created_at?: string
          email?: string | null
          full_name?: string
          id: string
          is_active?: boolean
          phone?: string | null
          role: Database['public']['Enums']['app_role']
          updated_at?: string
          whatsapp?: string | null
        }
        Update: {
          avatar_path?: string | null
          created_at?: string
          email?: string | null
          full_name?: string
          id?: string
          is_active?: boolean
          phone?: string | null
          role?: Database['public']['Enums']['app_role']
          updated_at?: string
          whatsapp?: string | null
        }
        Relationships: []
      }
      properties: {
        Row: {
          address_line: string | null
          agent_id: string | null
          area_m2: number | null
          availability: Database['public']['Enums']['availability_status']
          bathrooms: number | null
          bedrooms: number | null
          construction_progress: number | null
          created_at: string
          created_by: string | null
          currency: string
          delivery_date: string | null
          display_location: unknown
          floor_plan_path: string | null
          hide_exact_address: boolean
          id: string
          is_featured: boolean
          location: unknown
          lot_m2: number | null
          operation: Database['public']['Enums']['operation_type']
          parking: number | null
          price: number
          publication_status: Database['public']['Enums']['publication_status']
          published_at: string | null
          reference: number
          residency_eligible: boolean
          sold_at: string | null
          type: Database['public']['Enums']['property_type']
          updated_at: string
          video_url: string | null
          virtual_tour_url: string | null
          year_built: number | null
          zone_id: string | null
        }
        ComputedFields: never
        Insert: {
          address_line?: string | null
          agent_id?: string | null
          area_m2?: number | null
          availability?: Database['public']['Enums']['availability_status']
          bathrooms?: number | null
          bedrooms?: number | null
          construction_progress?: number | null
          created_at?: string
          created_by?: string | null
          currency?: string
          delivery_date?: string | null
          display_location?: unknown
          floor_plan_path?: string | null
          hide_exact_address?: boolean
          id?: string
          is_featured?: boolean
          location?: unknown
          lot_m2?: number | null
          operation?: Database['public']['Enums']['operation_type']
          parking?: number | null
          price: number
          publication_status?: Database['public']['Enums']['publication_status']
          published_at?: string | null
          reference?: never
          residency_eligible?: boolean
          sold_at?: string | null
          type: Database['public']['Enums']['property_type']
          updated_at?: string
          video_url?: string | null
          virtual_tour_url?: string | null
          year_built?: number | null
          zone_id?: string | null
        }
        Update: {
          address_line?: string | null
          agent_id?: string | null
          area_m2?: number | null
          availability?: Database['public']['Enums']['availability_status']
          bathrooms?: number | null
          bedrooms?: number | null
          construction_progress?: number | null
          created_at?: string
          created_by?: string | null
          currency?: string
          delivery_date?: string | null
          display_location?: unknown
          floor_plan_path?: string | null
          hide_exact_address?: boolean
          id?: string
          is_featured?: boolean
          location?: unknown
          lot_m2?: number | null
          operation?: Database['public']['Enums']['operation_type']
          parking?: number | null
          price?: number
          publication_status?: Database['public']['Enums']['publication_status']
          published_at?: string | null
          reference?: never
          residency_eligible?: boolean
          sold_at?: string | null
          type?: Database['public']['Enums']['property_type']
          updated_at?: string
          video_url?: string | null
          virtual_tour_url?: string | null
          year_built?: number | null
          zone_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'properties_agent_id_fkey'
            columns: ['agent_id']
            isOneToOne: false
            referencedRelation: 'profiles'
            referencedColumns: ['id']
          },
          {
            foreignKeyName: 'properties_created_by_fkey'
            columns: ['created_by']
            isOneToOne: false
            referencedRelation: 'profiles'
            referencedColumns: ['id']
          },
          {
            foreignKeyName: 'properties_zone_id_fkey'
            columns: ['zone_id']
            isOneToOne: false
            referencedRelation: 'zones'
            referencedColumns: ['id']
          },
        ]
      }
      property_amenities: {
        Row: {
          amenity_id: string
          property_id: string
        }
        ComputedFields: never
        Insert: {
          amenity_id: string
          property_id: string
        }
        Update: {
          amenity_id?: string
          property_id?: string
        }
        Relationships: [
          {
            foreignKeyName: 'property_amenities_amenity_id_fkey'
            columns: ['amenity_id']
            isOneToOne: false
            referencedRelation: 'amenities'
            referencedColumns: ['id']
          },
          {
            foreignKeyName: 'property_amenities_property_id_fkey'
            columns: ['property_id']
            isOneToOne: false
            referencedRelation: 'properties'
            referencedColumns: ['id']
          },
        ]
      }
      property_media: {
        Row: {
          created_at: string
          height: number | null
          id: string
          is_cover: boolean
          position: number
          property_id: string
          storage_path: string
          width: number | null
        }
        ComputedFields: never
        Insert: {
          created_at?: string
          height?: number | null
          id?: string
          is_cover?: boolean
          position?: number
          property_id: string
          storage_path: string
          width?: number | null
        }
        Update: {
          created_at?: string
          height?: number | null
          id?: string
          is_cover?: boolean
          position?: number
          property_id?: string
          storage_path?: string
          width?: number | null
        }
        Relationships: [
          {
            foreignKeyName: 'property_media_property_id_fkey'
            columns: ['property_id']
            isOneToOne: false
            referencedRelation: 'properties'
            referencedColumns: ['id']
          },
        ]
      }
      property_media_translations: {
        Row: {
          alt_text: string
          locale: string
          media_id: string
        }
        ComputedFields: never
        Insert: {
          alt_text: string
          locale: string
          media_id: string
        }
        Update: {
          alt_text?: string
          locale?: string
          media_id?: string
        }
        Relationships: [
          {
            foreignKeyName: 'property_media_translations_locale_fkey'
            columns: ['locale']
            isOneToOne: false
            referencedRelation: 'locales'
            referencedColumns: ['code']
          },
          {
            foreignKeyName: 'property_media_translations_media_id_fkey'
            columns: ['media_id']
            isOneToOne: false
            referencedRelation: 'property_media'
            referencedColumns: ['id']
          },
        ]
      }
      property_translations: {
        Row: {
          created_at: string
          description: string | null
          locale: string
          property_id: string
          seo_description: string | null
          seo_title: string | null
          short_description: string | null
          slug: string
          title: string
          updated_at: string
        }
        ComputedFields: never
        Insert: {
          created_at?: string
          description?: string | null
          locale: string
          property_id: string
          seo_description?: string | null
          seo_title?: string | null
          short_description?: string | null
          slug: string
          title: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          description?: string | null
          locale?: string
          property_id?: string
          seo_description?: string | null
          seo_title?: string | null
          short_description?: string | null
          slug?: string
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: 'property_translations_locale_fkey'
            columns: ['locale']
            isOneToOne: false
            referencedRelation: 'locales'
            referencedColumns: ['code']
          },
          {
            foreignKeyName: 'property_translations_property_id_fkey'
            columns: ['property_id']
            isOneToOne: false
            referencedRelation: 'properties'
            referencedColumns: ['id']
          },
        ]
      }
      property_units: {
        Row: {
          area_m2: number | null
          bathrooms: number | null
          bedrooms: number | null
          created_at: string
          currency: string
          floor: number | null
          id: string
          label: string
          price: number | null
          property_id: string
          sort_order: number
          status: Database['public']['Enums']['unit_status']
          updated_at: string
        }
        ComputedFields: never
        Insert: {
          area_m2?: number | null
          bathrooms?: number | null
          bedrooms?: number | null
          created_at?: string
          currency?: string
          floor?: number | null
          id?: string
          label: string
          price?: number | null
          property_id: string
          sort_order?: number
          status?: Database['public']['Enums']['unit_status']
          updated_at?: string
        }
        Update: {
          area_m2?: number | null
          bathrooms?: number | null
          bedrooms?: number | null
          created_at?: string
          currency?: string
          floor?: number | null
          id?: string
          label?: string
          price?: number | null
          property_id?: string
          sort_order?: number
          status?: Database['public']['Enums']['unit_status']
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: 'property_units_property_id_fkey'
            columns: ['property_id']
            isOneToOne: false
            referencedRelation: 'properties'
            referencedColumns: ['id']
          },
        ]
      }
      property_views: {
        Row: {
          id: number
          locale: string | null
          property_id: string
          viewed_at: string
        }
        ComputedFields: never
        Insert: {
          id?: never
          locale?: string | null
          property_id: string
          viewed_at?: string
        }
        Update: {
          id?: never
          locale?: string | null
          property_id?: string
          viewed_at?: string
        }
        Relationships: [
          {
            foreignKeyName: 'property_views_locale_fkey'
            columns: ['locale']
            isOneToOne: false
            referencedRelation: 'locales'
            referencedColumns: ['code']
          },
          {
            foreignKeyName: 'property_views_property_id_fkey'
            columns: ['property_id']
            isOneToOne: false
            referencedRelation: 'properties'
            referencedColumns: ['id']
          },
        ]
      }
      site_settings: {
        Row: {
          address_line: string | null
          email: string | null
          hero_image_path: string | null
          hero_property_id: string | null
          id: boolean
          lead_notification_emails: string[]
          lead_sla_minutes: number
          phone: string | null
          social: NonNullable<Json>
          updated_at: string
          whatsapp: string | null
        }
        ComputedFields: never
        Insert: {
          address_line?: string | null
          email?: string | null
          hero_image_path?: string | null
          hero_property_id?: string | null
          id?: boolean
          lead_notification_emails?: string[]
          lead_sla_minutes?: number
          phone?: string | null
          social?: NonNullable<Json>
          updated_at?: string
          whatsapp?: string | null
        }
        Update: {
          address_line?: string | null
          email?: string | null
          hero_image_path?: string | null
          hero_property_id?: string | null
          id?: boolean
          lead_notification_emails?: string[]
          lead_sla_minutes?: number
          phone?: string | null
          social?: NonNullable<Json>
          updated_at?: string
          whatsapp?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'site_settings_hero_property_id_fkey'
            columns: ['hero_property_id']
            isOneToOne: false
            referencedRelation: 'properties'
            referencedColumns: ['id']
          },
        ]
      }
      site_settings_translations: {
        Row: {
          hero_microcopy: string[]
          hero_tagline: string | null
          locale: string
          updated_at: string
        }
        ComputedFields: never
        Insert: {
          hero_microcopy?: string[]
          hero_tagline?: string | null
          locale: string
          updated_at?: string
        }
        Update: {
          hero_microcopy?: string[]
          hero_tagline?: string | null
          locale?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: 'site_settings_translations_locale_fkey'
            columns: ['locale']
            isOneToOne: true
            referencedRelation: 'locales'
            referencedColumns: ['code']
          },
        ]
      }
      testimonial_translations: {
        Row: {
          locale: string
          quote: string
          testimonial_id: string
        }
        ComputedFields: never
        Insert: {
          locale: string
          quote: string
          testimonial_id: string
        }
        Update: {
          locale?: string
          quote?: string
          testimonial_id?: string
        }
        Relationships: [
          {
            foreignKeyName: 'testimonial_translations_locale_fkey'
            columns: ['locale']
            isOneToOne: false
            referencedRelation: 'locales'
            referencedColumns: ['code']
          },
          {
            foreignKeyName: 'testimonial_translations_testimonial_id_fkey'
            columns: ['testimonial_id']
            isOneToOne: false
            referencedRelation: 'testimonials'
            referencedColumns: ['id']
          },
        ]
      }
      testimonials: {
        Row: {
          author_country: string | null
          author_name: string
          created_at: string
          id: string
          is_published: boolean
          property_id: string | null
          sort_order: number
          updated_at: string
        }
        ComputedFields: never
        Insert: {
          author_country?: string | null
          author_name: string
          created_at?: string
          id?: string
          is_published?: boolean
          property_id?: string | null
          sort_order?: number
          updated_at?: string
        }
        Update: {
          author_country?: string | null
          author_name?: string
          created_at?: string
          id?: string
          is_published?: boolean
          property_id?: string | null
          sort_order?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: 'testimonials_property_id_fkey'
            columns: ['property_id']
            isOneToOne: false
            referencedRelation: 'properties'
            referencedColumns: ['id']
          },
        ]
      }
      zone_translations: {
        Row: {
          description: string | null
          locale: string
          name: string
          slug: string
          zone_id: string
        }
        ComputedFields: never
        Insert: {
          description?: string | null
          locale: string
          name: string
          slug: string
          zone_id: string
        }
        Update: {
          description?: string | null
          locale?: string
          name?: string
          slug?: string
          zone_id?: string
        }
        Relationships: [
          {
            foreignKeyName: 'zone_translations_locale_fkey'
            columns: ['locale']
            isOneToOne: false
            referencedRelation: 'locales'
            referencedColumns: ['code']
          },
          {
            foreignKeyName: 'zone_translations_zone_id_fkey'
            columns: ['zone_id']
            isOneToOne: false
            referencedRelation: 'zones'
            referencedColumns: ['id']
          },
        ]
      }
      zones: {
        Row: {
          center: unknown
          created_at: string
          id: string
          is_active: boolean
          sort_order: number
          updated_at: string
        }
        ComputedFields: never
        Insert: {
          center?: unknown
          created_at?: string
          id?: string
          is_active?: boolean
          sort_order?: number
          updated_at?: string
        }
        Update: {
          center?: unknown
          created_at?: string
          id?: string
          is_active?: boolean
          sort_order?: number
          updated_at?: string
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      agent_ranking: {
        Args: { p_from: string; p_to: string }
        Returns: {
          agent_id: string
          avg_first_response_minutes: number
          full_name: string
          leads_assigned: number
          won: number
        }[]
      }
      custom_access_token_hook: { Args: { event: Json }; Returns: Json }
      dashboard_kpis: { Args: { p_from: string; p_to: string }; Returns: Json }
      demand_by_zone: {
        Args: { p_from: string; p_to: string }
        Returns: {
          active_properties: number
          lat: number
          leads: number
          lng: number
          name: string
          zone_id: string
        }[]
      }
      inventory_health: {
        Args: Record<PropertyKey, never>
        Returns: {
          issues: string[]
          property_id: string
          reference: number
          title: string
        }[]
      }
      lead_funnel: {
        Args: { p_from: string; p_to: string }
        Returns: {
          reached: number
          stage: Database['public']['Enums']['lead_stage']
        }[]
      }
      leads_breakdown: {
        Args: { p_dimension: string; p_from: string; p_to: string }
        Returns: {
          key: string
          leads: number
        }[]
      }
      leads_by_month: {
        Args: { p_months?: number }
        Returns: {
          leads: number
          month: string
          won: number
          won_value_usd: number
        }[]
      }
      search_properties: {
        Args: {
          p_amenity_keys?: string[]
          p_bbox?: number[]
          p_currency?: string
          p_has_tour?: boolean
          p_limit?: number
          p_locale: string
          p_max_area?: number
          p_max_price?: number
          p_min_area?: number
          p_min_bathrooms?: number
          p_min_bedrooms?: number
          p_min_price?: number
          p_offset?: number
          p_residency?: boolean
          p_sort?: string
          p_types?: Database['public']['Enums']['property_type'][]
          p_zone_ids?: string[]
        }
        Returns: {
          area_m2: number
          availability: Database['public']['Enums']['availability_status']
          bathrooms: number
          bedrooms: number
          cover_path: string
          currency: string
          has_virtual_tour: boolean
          id: string
          is_fallback: boolean
          is_featured: boolean
          lat: number
          lng: number
          locale: string
          price: number
          reference: number
          residency_eligible: boolean
          short_description: string
          slug: string
          title: string
          total_count: number
          type: Database['public']['Enums']['property_type']
          zone_id: string
          zone_name: string
        }[]
      }
      top_properties: {
        Args: { p_from: string; p_limit?: number; p_order?: string; p_to: string }
        Returns: {
          leads: number
          property_id: string
          reference: number
          title: string
          views: number
          views_per_lead: number
        }[]
      }
    }
    Enums: {
      app_role: 'admin' | 'agent' | 'editor'
      availability_status: 'available' | 'reserved' | 'sold'
      contact_channel: 'whatsapp' | 'phone' | 'email' | 'video_call'
      lead_event_type:
        | 'created'
        | 'stage_changed'
        | 'assigned'
        | 'note'
        | 'call'
        | 'email'
        | 'whatsapp'
        | 'reminder'
      lead_goal: 'invest' | 'live' | 'both'
      lead_interest: 'visit' | 'video_call' | 'info' | 'financing'
      lead_source: 'property_form' | 'contact_form' | 'whatsapp' | 'phone' | 'other'
      lead_stage: 'new' | 'contacted' | 'visit_scheduled' | 'negotiation' | 'won' | 'lost'
      operation_type: 'sale'
      property_type: 'house' | 'apartment' | 'condominium'
      publication_status: 'draft' | 'published' | 'archived'
      unit_status: 'available' | 'reserved' | 'sold'
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, '__InternalSupabase'>

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, 'public'>]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema['Tables'] & DefaultSchema['Views'])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables'] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Views'])
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends { schema: keyof DatabaseWithoutInternals }
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables'] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Views'])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema['Tables'] & DefaultSchema['Views'])
    ? (DefaultSchema['Tables'] & DefaultSchema['Views'])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    keyof DefaultSchema['Tables'] | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables']
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends { schema: keyof DatabaseWithoutInternals }
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables'][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema['Tables']
    ? DefaultSchema['Tables'][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    keyof DefaultSchema['Tables'] | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables']
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends { schema: keyof DatabaseWithoutInternals }
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables'][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema['Tables']
    ? DefaultSchema['Tables'][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    keyof DefaultSchema['Enums'] | { schema: keyof DatabaseWithoutInternals },
  EnumName extends (DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions['schema']]['Enums']
    : never) = never,
> = DefaultSchemaEnumNameOrOptions extends { schema: keyof DatabaseWithoutInternals }
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions['schema']]['Enums'][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema['Enums']
    ? DefaultSchema['Enums'][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    keyof DefaultSchema['CompositeTypes'] | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends (PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions['schema']]['CompositeTypes']
    : never) = never,
> = PublicCompositeTypeNameOrOptions extends { schema: keyof DatabaseWithoutInternals }
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions['schema']]['CompositeTypes'][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema['CompositeTypes']
    ? DefaultSchema['CompositeTypes'][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      app_role: ['admin', 'agent', 'editor'],
      availability_status: ['available', 'reserved', 'sold'],
      contact_channel: ['whatsapp', 'phone', 'email', 'video_call'],
      lead_event_type: [
        'created',
        'stage_changed',
        'assigned',
        'note',
        'call',
        'email',
        'whatsapp',
        'reminder',
      ],
      lead_goal: ['invest', 'live', 'both'],
      lead_interest: ['visit', 'video_call', 'info', 'financing'],
      lead_source: ['property_form', 'contact_form', 'whatsapp', 'phone', 'other'],
      lead_stage: ['new', 'contacted', 'visit_scheduled', 'negotiation', 'won', 'lost'],
      operation_type: ['sale'],
      property_type: ['house', 'apartment', 'condominium'],
      publication_status: ['draft', 'published', 'archived'],
      unit_status: ['available', 'reserved', 'sold'],
    },
  },
} as const
