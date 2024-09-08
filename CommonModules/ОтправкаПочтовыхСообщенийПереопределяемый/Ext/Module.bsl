﻿
#Область ПрограммныйИнтерфейс

// Возвращает подпись пользователя, используемую для отправки почтовых сообщений.
//
// Возвращаемое значение:
//  Строка - подпись в формате HTML.
//
Функция ПодписьПисьма() Экспорт
	
	Возврат БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("Подпись");
	
КонецФункции

// Возвращает адреса электронной почты из контактной информации контрагента и его контактных лиц.
//
// Параметры:
//	Контрагент - СправочникСсылка.Контрагенты - Контрагент, для которого определяется адрес.
//
// Возвращаемое значение:
//	Массив - Массив структур, см. ОтправкаПочтовыхСообщений.НовыеПараметрыПолучателя().
//
Функция АдресаЭлектроннойПочты(Контрагент) Экспорт
	
	Получатели = Новый Массив;
	
	ТипыКИ = Новый Массив;
	ТипыКИ.Добавить(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	
	Объекты = Новый Массив();
	Объекты.Добавить(Контрагент);
	АдресаПолучателя = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(Объекты, ТипыКИ, , ТекущаяДатаСеанса());
	
	КонтрагентНаименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "Наименование");
	
	Для каждого АдресПолучателя Из АдресаПолучателя Цикл

		ПараметрыПолучателя = ОтправкаПочтовыхСообщений.НовыеПараметрыПолучателя();
		ПараметрыПолучателя.ИсточникКонтактнойИнформации 	= Контрагент;
		ПараметрыПолучателя.Адрес 							= АдресПолучателя.Представление;
		ПараметрыПолучателя.Представление 					= КонтрагентНаименование;
		Получатели.Добавить(ПараметрыПолучателя);

	КонецЦикла;
		
	Возврат Получатели;
	
КонецФункции

#КонецОбласти
