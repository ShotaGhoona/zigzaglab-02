// ZIGZAGLAB Database Types
// Generated for TypeScript integration with Supabase

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      admin_users: {
        Row: {
          id: string
          clerk_user_id: string
          name: string
          email: string
          role: 'admin' | 'editor'
          is_active: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          clerk_user_id: string
          name: string
          email: string
          role: 'admin' | 'editor'
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          clerk_user_id?: string
          name?: string
          email?: string
          role?: 'admin' | 'editor'
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      news: {
        Row: {
          id: string
          title: string
          content: string
          slug: string
          status: 'draft' | 'published' | 'archived'
          meta_title: string | null
          meta_description: string | null
          created_by: string | null
          updated_by: string | null
          published_at: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          title: string
          content: string
          slug: string
          status?: 'draft' | 'published' | 'archived'
          meta_title?: string | null
          meta_description?: string | null
          created_by?: string | null
          updated_by?: string | null
          published_at?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          title?: string
          content?: string
          slug?: string
          status?: 'draft' | 'published' | 'archived'
          meta_title?: string | null
          meta_description?: string | null
          created_by?: string | null
          updated_by?: string | null
          published_at?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      products: {
        Row: {
          id: string
          name: string
          description: string
          category: 'badge' | 'acrylic' | 'patent' | 'other'
          slug: string
          price_min: number | null
          price_max: number | null
          specifications: string | null
          features: string | null
          is_featured: boolean
          status: 'active' | 'inactive' | 'discontinued'
          meta_title: string | null
          meta_description: string | null
          created_by: string | null
          updated_by: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          description: string
          category: 'badge' | 'acrylic' | 'patent' | 'other'
          slug: string
          price_min?: number | null
          price_max?: number | null
          specifications?: string | null
          features?: string | null
          is_featured?: boolean
          status?: 'active' | 'inactive' | 'discontinued'
          meta_title?: string | null
          meta_description?: string | null
          created_by?: string | null
          updated_by?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          description?: string
          category?: 'badge' | 'acrylic' | 'patent' | 'other'
          slug?: string
          price_min?: number | null
          price_max?: number | null
          specifications?: string | null
          features?: string | null
          is_featured?: boolean
          status?: 'active' | 'inactive' | 'discontinued'
          meta_title?: string | null
          meta_description?: string | null
          created_by?: string | null
          updated_by?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      inquiries: {
        Row: {
          id: string
          inquiry_type: 'estimate' | 'general' | 'sample'
          company_name: string | null
          contact_name: string
          email: string
          phone: string | null
          subject: string
          message: string
          product_category: 'badge' | 'acrylic' | 'patent' | 'other' | null
          quantity: number | null
          status: 'new' | 'in_progress' | 'replied' | 'closed'
          admin_notes: string | null
          assigned_to: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          inquiry_type: 'estimate' | 'general' | 'sample'
          company_name?: string | null
          contact_name: string
          email: string
          phone?: string | null
          subject: string
          message: string
          product_category?: 'badge' | 'acrylic' | 'patent' | 'other' | null
          quantity?: number | null
          status?: 'new' | 'in_progress' | 'replied' | 'closed'
          admin_notes?: string | null
          assigned_to?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          inquiry_type?: 'estimate' | 'general' | 'sample'
          company_name?: string | null
          contact_name?: string
          email?: string
          phone?: string | null
          subject?: string
          message?: string
          product_category?: 'badge' | 'acrylic' | 'patent' | 'other' | null
          quantity?: number | null
          status?: 'new' | 'in_progress' | 'replied' | 'closed'
          admin_notes?: string | null
          assigned_to?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      tags: {
        Row: {
          id: string
          name: string
          color: string | null
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          color?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          name?: string
          color?: string | null
          created_at?: string
        }
      }
      taggables: {
        Row: {
          id: string
          tag_id: string
          entity_type: 'news' | 'product' | 'achievement'
          entity_id: string
          created_at: string
        }
        Insert: {
          id?: string
          tag_id: string
          entity_type: 'news' | 'product' | 'achievement'
          entity_id: string
          created_at?: string
        }
        Update: {
          id?: string
          tag_id?: string
          entity_type?: 'news' | 'product' | 'achievement'
          entity_id?: string
          created_at?: string
        }
      }
      files: {
        Row: {
          id: string
          original_name: string
          file_path: string
          file_type: string
          file_size: number
          usage_type: 'thumbnail' | 'inline' | 'attachment'
          sort_order: number | null
          caption: string | null
          alt_text: string | null
          entity_type: 'news' | 'product' | 'inquiry'
          entity_id: string
          created_at: string
        }
        Insert: {
          id?: string
          original_name: string
          file_path: string
          file_type: string
          file_size: number
          usage_type: 'thumbnail' | 'inline' | 'attachment'
          sort_order?: number | null
          caption?: string | null
          alt_text?: string | null
          entity_type: 'news' | 'product' | 'inquiry'
          entity_id: string
          created_at?: string
        }
        Update: {
          id?: string
          original_name?: string
          file_path?: string
          file_type?: string
          file_size?: number
          usage_type?: 'thumbnail' | 'inline' | 'attachment'
          sort_order?: number | null
          caption?: string | null
          alt_text?: string | null
          entity_type?: 'news' | 'product' | 'inquiry'
          entity_id?: string
          created_at?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}