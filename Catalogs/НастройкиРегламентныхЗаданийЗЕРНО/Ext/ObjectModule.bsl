﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьХешСуммуПараметровНастройкиОбмена();
	ПроверитьДубли(Отказ);
	
	Если Не Отказ Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Если ЗначениеЗаполнено(РегламентноеЗадание) Тогда
			Задание = РегламентныеЗаданияСервер.Задание(РегламентноеЗадание);
		Иначе
			Задание = Неопределено;
		КонецЕсли;
		
		Если Задание = Неопределено Тогда
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("Метаданные",    Метаданные.РегламентныеЗадания.ОтправкаПолучениеДанныхЗЕРНО);
			ПараметрыЗадания.Вставить("Использование", Ложь);
			ПараметрыЗадания.Вставить("Наименование",  Наименование);
			ПараметрыЗадания.Вставить("Ключ",          Строка(Новый УникальныйИдентификатор));
			
			Если ЗначениеЗаполнено(Ссылка) Тогда
				ЭтаСсылка = Ссылка;
			Иначе
				ЭтаСсылка = Справочники.НастройкиРегламентныхЗаданийЗЕРНО.ПолучитьСсылку();
				УстановитьСсылкуНового(ЭтаСсылка);
			КонецЕсли;
			
			Параметры = Новый Массив;
			Параметры.Добавить(ЭтаСсылка);
			ПараметрыЗадания.Вставить("Параметры", Параметры);
			
			Задание = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
			
			РегламентноеЗадание = РегламентныеЗаданияСервер.УникальныйИдентификатор(Задание);
		КонецЕсли;
		
		ДополнительныеСвойства.Вставить("Задание", Задание);
		
		ВидНастройкиОбменДанными = Перечисления.ВидыНастроекОбменаЗЕРНО.ОбменДанными;
		Если ВидНастройкиОбмена = ВидНастройкиОбменДанными
			Или (Не Ссылка.Пустая()
				И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ВидНастройкиОбмена") = ВидНастройкиОбменДанными) Тогда
			ДополнительныеСвойства.Вставить("ОбновитьПовторноИспользуемыеЗначения", Истина);
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Если ДополнительныеСвойства.Свойство("Задание") Тогда
			
			ПараметрыЗадания = Новый Структура;
			
			Если ДополнительныеСвойства.Свойство("Расписание") 
				И ТипЗнч(ДополнительныеСвойства.Расписание) = Тип("РасписаниеРегламентногоЗадания") Тогда
				ПараметрыЗадания.Вставить("Расписание", ДополнительныеСвойства.Расписание);
			КонецЕсли;
			
			Если ПометкаУдаления Тогда
				ПараметрыЗадания.Вставить("Использование", Ложь);
			ИначеЕсли ДополнительныеСвойства.Свойство("Использование") Тогда
				ПараметрыЗадания.Вставить("Использование", ДополнительныеСвойства.Использование);
			КонецЕсли;
			
			ПараметрыЗадания.Вставить("Наименование", Наименование);
			
			Параметры = Новый Массив;
			Параметры.Добавить(Ссылка);
			ПараметрыЗадания.Вставить("Параметры", Параметры);
			
			УстановитьПривилегированныйРежим(Истина);
			РегламентныеЗаданияСервер.ИзменитьЗадание(РегламентноеЗадание, ПараметрыЗадания);
			
		КонецЕсли;
		
		Если ДополнительныеСвойства.Свойство("ОбновитьПовторноИспользуемыеЗначения") Тогда
			ОбновитьПовторноИспользуемыеЗначения();
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ЗначениеЗаполнено(РегламентноеЗадание) Тогда
		УстановитьПривилегированныйРежим(Истина);
		РегламентныеЗаданияСервер.УдалитьЗадание(РегламентноеЗадание);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	РегламентноеЗадание = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьХешСуммуПараметровНастройкиОбмена()
	
	ХешСуммаПараметровНастроекОбмена = Справочники.НастройкиРегламентныхЗаданийЗЕРНО.ХешСуммаПараметровНастройкиОбмена(
		ВидНастройкиОбмена, ПараметрыНастройкиОбмена.Получить());
	
КонецПроцедуры

Процедура ПроверитьДубли(Отказ)
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",                           Ссылка);
	Запрос.УстановитьПараметр("Организация",                      Организация);
	Запрос.УстановитьПараметр("Подразделение",                    Подразделение);
	Запрос.УстановитьПараметр("ВидНастройкиОбмена",               ВидНастройкиОбмена);
	Запрос.УстановитьПараметр("ХешСуммаПараметровНастроекОбмена", ХешСуммаПараметровНастроекОбмена);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПРЕДСТАВЛЕНИЕ(НастройкиОбменаЗЕРНО.Ссылка) КАК НастройкаОбменаПредставление,
	|	ПРЕДСТАВЛЕНИЕ(НастройкиОбменаЗЕРНО.Организация) КАК ОрганизацияПредставление,
	|	ПРЕДСТАВЛЕНИЕ(НастройкиОбменаЗЕРНО.Подразделение) КАК ПодразделениеПредставление,
	|	ПРЕДСТАВЛЕНИЕ(НастройкиОбменаЗЕРНО.ВидНастройкиОбмена) КАК ВидНастройкиОбменаПредставление
	|ИЗ
	|	Справочник.НастройкиРегламентныхЗаданийЗЕРНО КАК НастройкиОбменаЗЕРНО
	|ГДЕ
	|	НастройкиОбменаЗЕРНО.Ссылка <> &Ссылка
	|	И НЕ НастройкиОбменаЗЕРНО.ПометкаУдаления
	|	И НастройкиОбменаЗЕРНО.Организация = &Организация
	|	И НастройкиОбменаЗЕРНО.Подразделение = &Подразделение
	|	И НастройкиОбменаЗЕРНО.ВидНастройкиОбмена = &ВидНастройкиОбмена
	|	И НастройкиОбменаЗЕРНО.ХешСуммаПараметровНастроекОбмена = &ХешСуммаПараметровНастроекОбмена";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если ОбщегоНазначенияИС.ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс()
			И ЗначениеЗаполнено(Выборка.ПодразделениеПредставление) Тогда
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр
				("ru = 'По организации %1, подразделению %2, вид настройки %3, уже существует настройка обмена %4'"),
				Выборка.ОрганизацияПредставление,
				Выборка.ПодразделениеПредставление,
				Выборка.ВидНастройкиОбменаПредставление,
				Выборка.НастройкаОбменаПредставление),,,,
				Отказ);
		Иначе
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр
				("ru = 'По организации %1, вид настройки %2, уже существует настройка обмена %3'"),
				Выборка.ОрганизацияПредставление,
				Выборка.ВидНастройкиОбменаПредставление,
				Выборка.НастройкаОбменаПредставление),,,,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли